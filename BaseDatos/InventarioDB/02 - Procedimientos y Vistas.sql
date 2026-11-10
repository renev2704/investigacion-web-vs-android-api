/* =====================================================================
   SISTEMA DE INVENTARIO - BASE DE DATOS (SQL Server 2022)
   Script 02: vistas y procedimientos almacenados.

   Contenido
     Vistas
       dbo.vw_ProductosDetalle      -> productos + nombre de categoría + alerta de stock bajo
       dbo.vw_ResumenMediciones     -> estadística descriptiva por celda experimental
       dbo.vw_ProgresoExperimento   -> cuántas repeticiones lleva cada una de las 24 celdas
     Procedimientos
       dbo.sp_RestablecerCategorias -> deja las 10 categorías base con IDs 1..10
       dbo.sp_RegistrarMovimiento   -> entrada/salida/ajuste de stock (transaccional)
       dbo.sp_GenerarDatosPrueba    -> seeding reproducible (semilla 42) de N productos
       dbo.sp_LimpiarCache          -> limpia la caché de SQL Server entre series

   Ejecutar después de 01_crear_base_datos.sql
   ===================================================================== */

USE InventarioDB;
GO

/* =====================================================================
   VISTAS
   ===================================================================== */

/* ---------------------------------------------------------------------
   vw_ProductosDetalle
   Útil para pantallas de listado (web y app) que muestran la categoría
   por nombre y resaltan los productos con stock bajo.
   --------------------------------------------------------------------- */
CREATE OR ALTER VIEW dbo.vw_ProductosDetalle
AS
SELECT
    p.ProductoId,
    p.Codigo,
    p.Nombre,
    p.Descripcion,
    p.CategoriaId,
    c.Nombre                        AS CategoriaNombre,
    p.PrecioUnitario,
    p.Stock,
    p.StockMinimo,
    CAST(CASE WHEN p.Stock <= p.StockMinimo THEN 1 ELSE 0 END AS BIT) AS BajoStock,
    p.Activo,
    p.FechaCreacion,
    p.FechaActualizacion
FROM dbo.Productos  AS p
JOIN dbo.Categorias AS c ON c.CategoriaId = p.CategoriaId;
GO

/* ---------------------------------------------------------------------
   vw_ResumenMediciones
   Etapa 1 del plan de análisis: media, mediana, desviación estándar y
   coeficiente de variación por celda (sin ejecuciones de calentamiento).
   El análisis inferencial se hace en Python (pandas / scipy).
   --------------------------------------------------------------------- */
CREATE OR ALTER VIEW dbo.vw_ResumenMediciones
AS
WITH validas AS (
    SELECT
        m.Plataforma, m.Volumen, m.Operacion, m.TiempoRespuestaMs, m.MemoriaMB,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY m.TiempoRespuestaMs)
            OVER (PARTITION BY m.Plataforma, m.Volumen, m.Operacion) AS MedianaMs
    FROM dbo.Mediciones AS m
    WHERE m.EsCalentamiento = 0
)
SELECT
    Plataforma,
    Volumen,
    Operacion,
    COUNT(*)                                                         AS N,
    CAST(AVG(TiempoRespuestaMs)   AS DECIMAL(12,3))                  AS MediaMs,
    CAST(MAX(MedianaMs)           AS DECIMAL(12,3))                  AS MedianaMs,
    CAST(STDEV(TiempoRespuestaMs) AS DECIMAL(12,3))                  AS DesvEstMs,
    CAST(STDEV(TiempoRespuestaMs) * 100.0
         / NULLIF(AVG(TiempoRespuestaMs), 0) AS DECIMAL(8,2))        AS CVPorcentajeMs,
    MIN(TiempoRespuestaMs)                                           AS MinMs,
    MAX(TiempoRespuestaMs)                                           AS MaxMs,
    CAST(AVG(MemoriaMB)           AS DECIMAL(10,3))                  AS MediaMB,
    CAST(STDEV(MemoriaMB)         AS DECIMAL(10,3))                  AS DesvEstMB,
    MAX(MemoriaMB)                                                   AS MaxMB
FROM validas
GROUP BY Plataforma, Volumen, Operacion;
GO

/* ---------------------------------------------------------------------
   vw_ProgresoExperimento
   Muestra las 24 celdas (2 x 3 x 4) y cuántas repeticiones válidas y
   de calentamiento se han registrado. Meta: 10 válidas + 5 calentamiento.
   --------------------------------------------------------------------- */
CREATE OR ALTER VIEW dbo.vw_ProgresoExperimento
AS
SELECT
    pl.Plataforma,
    vo.Volumen,
    op.Operacion,
    SUM(CASE WHEN m.MedicionId IS NOT NULL AND m.EsCalentamiento = 0 THEN 1 ELSE 0 END) AS RepeticionesValidas,
    SUM(CASE WHEN m.MedicionId IS NOT NULL AND m.EsCalentamiento = 1 THEN 1 ELSE 0 END) AS Calentamientos,
    CAST(CASE WHEN SUM(CASE WHEN m.MedicionId IS NOT NULL AND m.EsCalentamiento = 0 THEN 1 ELSE 0 END) >= 10
              THEN 1 ELSE 0 END AS BIT)                                                   AS Completa
FROM       (VALUES ('WEB'), ('ANDROID'))                                   AS pl(Plataforma)
CROSS JOIN (VALUES (1000), (10000), (100000))                              AS vo(Volumen)
CROSS JOIN (VALUES ('CREATE'), ('READ'), ('UPDATE'), ('DELETE'))           AS op(Operacion)
LEFT JOIN  dbo.Mediciones AS m
       ON  m.Plataforma = pl.Plataforma
       AND m.Volumen    = vo.Volumen
       AND m.Operacion  = op.Operacion
GROUP BY pl.Plataforma, vo.Volumen, op.Operacion;
GO

/* =====================================================================
   PROCEDIMIENTOS
   ===================================================================== */

/* ---------------------------------------------------------------------
   sp_RestablecerCategorias
   Fuente única de las 10 categorías base (IDs fijos 1..10).
   Solo se puede ejecutar cuando no hay productos que usen categorías
   distintas de las base (sp_GenerarDatosPrueba lo llama tras vaciar
   la tabla Productos).
   --------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE dbo.sp_RestablecerCategorias
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @Base TABLE (CategoriaId INT PRIMARY KEY, Nombre NVARCHAR(100), Descripcion NVARCHAR(255));
    INSERT INTO @Base (CategoriaId, Nombre, Descripcion) VALUES
     (1,  N'Electrónica', N'Dispositivos y componentes electrónicos'),
     (2,  N'Computación', N'Equipos de cómputo y accesorios'),
     (3,  N'Papelería',   N'Útiles y artículos de oficina'),
     (4,  N'Limpieza',    N'Productos de limpieza e higiene'),
     (5,  N'Ferretería',  N'Herramientas y materiales de construcción'),
     (6,  N'Alimentos',   N'Productos alimenticios no perecederos'),
     (7,  N'Bebidas',     N'Bebidas embotelladas y enlatadas'),
     (8,  N'Hogar',       N'Artículos para el hogar'),
     (9,  N'Mobiliario',  N'Muebles de oficina y hogar'),
     (10, N'Telefonía',   N'Teléfonos y accesorios móviles');

    BEGIN TRANSACTION;

        -- Elimina categorías creadas durante las pruebas (ID > 10)
        DELETE c
        FROM dbo.Categorias AS c
        WHERE c.CategoriaId NOT IN (SELECT CategoriaId FROM @Base);

        -- Restaura nombre/descripcion/estado de las existentes
        UPDATE c
           SET c.Nombre = b.Nombre, c.Descripcion = b.Descripcion, c.Activo = 1
        FROM dbo.Categorias AS c
        JOIN @Base AS b ON b.CategoriaId = c.CategoriaId;

        -- Inserta las que falten conservando su ID
        SET IDENTITY_INSERT dbo.Categorias ON;
        INSERT INTO dbo.Categorias (CategoriaId, Nombre, Descripcion)
        SELECT b.CategoriaId, b.Nombre, b.Descripcion
        FROM @Base AS b
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Categorias c WHERE c.CategoriaId = b.CategoriaId);
        SET IDENTITY_INSERT dbo.Categorias OFF;

        -- La próxima categoría creada por la API tendrá ID 11
        DBCC CHECKIDENT ('dbo.Categorias', RESEED, 10) WITH NO_INFOMSGS;

    COMMIT TRANSACTION;
END
GO

/* ---------------------------------------------------------------------
   sp_RegistrarMovimiento
   Registra una entrada, salida o ajuste y actualiza el stock del
   producto en una sola transacción (bloqueo de fila para evitar
   condiciones de carrera entre la web y la app).

   Parámetros
     @ProductoId      INT
     @TipoMovimiento  'ENTRADA' | 'SALIDA' | 'AJUSTE'
     @Cantidad        ENTRADA/SALIDA: > 0.   AJUSTE: +n suma, -n resta.
     @Comentario      opcional

   Devuelve: la fila del movimiento registrado.

   Errores (THROW) -> sugerencia de código HTTP en la API
     50001  Producto no encontrado              -> 404
     50002  Tipo o cantidad inválidos           -> 400
     50003  Stock insuficiente                  -> 409
     50004  Producto inactivo                   -> 409
   --------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE dbo.sp_RegistrarMovimiento
    @ProductoId     INT,
    @TipoMovimiento VARCHAR(10),
    @Cantidad       INT,
    @Comentario     NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @TipoMovimiento = UPPER(LTRIM(RTRIM(@TipoMovimiento)));

    IF @TipoMovimiento NOT IN ('ENTRADA','SALIDA','AJUSTE')
        THROW 50002, N'Tipo de movimiento inválido. Use ENTRADA, SALIDA o AJUSTE.', 1;

    IF @Cantidad IS NULL
       OR (@TipoMovimiento IN ('ENTRADA','SALIDA') AND @Cantidad <= 0)
       OR (@TipoMovimiento = 'AJUSTE' AND @Cantidad = 0)
        THROW 50002, N'Cantidad inválida para el tipo de movimiento.', 1;

    DECLARE @StockAnterior INT, @Activo BIT, @StockNuevo INT;
    DECLARE @Resultado TABLE (MovimientoId BIGINT);

    BEGIN TRY
        BEGIN TRANSACTION;

            SELECT @StockAnterior = Stock, @Activo = Activo
            FROM dbo.Productos WITH (UPDLOCK, ROWLOCK)
            WHERE ProductoId = @ProductoId;

            IF @StockAnterior IS NULL
                THROW 50001, N'El producto no existe.', 1;

            IF @Activo = 0
                THROW 50004, N'El producto está inactivo.', 1;

            SET @StockNuevo = @StockAnterior +
                CASE @TipoMovimiento
                    WHEN 'ENTRADA' THEN  @Cantidad
                    WHEN 'SALIDA'  THEN -@Cantidad
                    ELSE                 @Cantidad      -- AJUSTE (con signo)
                END;

            IF @StockNuevo < 0
                THROW 50003, N'Stock insuficiente para realizar el movimiento.', 1;

            UPDATE dbo.Productos
               SET Stock = @StockNuevo,
                   FechaActualizacion = SYSDATETIME()
             WHERE ProductoId = @ProductoId;

            INSERT INTO dbo.MovimientosInventario
                   (ProductoId, TipoMovimiento, Cantidad, StockAnterior, StockResultante, Comentario)
            OUTPUT inserted.MovimientoId INTO @Resultado (MovimientoId)
            VALUES (@ProductoId, @TipoMovimiento, @Cantidad, @StockAnterior, @StockNuevo, @Comentario);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH

    SELECT mv.MovimientoId, mv.ProductoId, mv.TipoMovimiento, mv.Cantidad,
           mv.StockAnterior, mv.StockResultante, mv.Comentario, mv.FechaMovimiento
    FROM dbo.MovimientosInventario AS mv
    JOIN @Resultado AS r ON r.MovimientoId = mv.MovimientoId;
END
GO

/* ---------------------------------------------------------------------
   sp_GenerarDatosPrueba  (script SQL de seeding con semilla fija)
   - Vacía Productos y MovimientosInventario (NO toca Mediciones).
   - Restablece las 10 categorías base.
   - Genera @Cantidad productos sintéticos con ProductoId = 1..@Cantidad.
   - Mismo @Cantidad + misma @Semilla  =>  exactamente los mismos datos
     (se usa HASHBYTES, no RAND/NEWID, por eso es reproducible).
   - Reconstruye índices al final para que todas las series partan de
     la misma condición física.

   Uso:   EXEC dbo.sp_GenerarDatosPrueba @Cantidad = 1000;     -- 10000 / 100000
   Requiere permisos de administrador (db_owner): ejecutar desde SSMS,
   NO desde la API.
   --------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE dbo.sp_GenerarDatosPrueba
    @Cantidad   INT,
    @Semilla    INT = 42
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @Cantidad IS NULL OR @Cantidad < 1 OR @Cantidad > 999999
        THROW 50010, N'La cantidad debe estar entre 1 y 999999 (experimento: 1000, 10000 o 100000).', 1;

    DECLARE @Inicio DATETIME2(3) = SYSDATETIME();

    BEGIN TRY
        BEGIN TRANSACTION;

            /* 1. Vaciar datos de inventario */
            DELETE FROM dbo.MovimientosInventario;
            DELETE FROM dbo.Productos;

            /* 2. Categorías base 1..10 */
            EXEC dbo.sp_RestablecerCategorias;

            /* 3. Generar productos */
            SET IDENTITY_INSERT dbo.Productos ON;

            WITH d AS (
                SELECT v FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS t(v)
            ),
            numeros AS (                                   -- hasta 1.000.000 filas
                SELECT TOP (@Cantidad)
                       CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS INT) AS n
                FROM d a CROSS JOIN d b CROSS JOIN d c
                CROSS JOIN d e CROSS JOIN d f CROSS JOIN d g
                ORDER BY n
            )
            INSERT INTO dbo.Productos
                   (ProductoId, Codigo, Nombre, Descripcion, CategoriaId,
                    PrecioUnitario, Stock, StockMinimo, Activo, FechaCreacion, FechaActualizacion)
            SELECT
                nu.n,
                CONCAT('PRD-', RIGHT(CONCAT('000000', nu.n), 6)),
                CONCAT(
                    CHOOSE(1 + r.r1 % 12, N'Caja', N'Paquete', N'Kit', N'Juego', N'Unidad', N'Set',
                                           N'Rollo', N'Bolsa', N'Estuche', N'Pieza', N'Docena', N'Bulto'),
                    N' ',
                    CHOOSE(1 + r.r2 % 10, N'Básico', N'Estándar', N'Premium', N'Profesional', N'Compacto',
                                           N'Industrial', N'Económico', N'Deluxe', N'Plus', N'Eco'),
                    N' ',
                    CHOOSE(1 + r.r3 % 10, N'Alfa', N'Nova', N'Delta', N'Orion', N'Vértice',
                                           N'Cumbre', N'Atlas', N'Lince', N'Sol', N'Quetzal'),
                    N' M-', RIGHT(CONCAT('0000', r.r4 % 10000), 4)
                ),
                CONCAT(N'Producto sintético de prueba n.° ', nu.n,
                       N'. Generado con semilla ', @Semilla, N' para el experimento de rendimiento.'),
                CAST(1 + r.r5 % 10 AS INT),                                     -- CategoriaId 1..10
                CAST((r.r6 % 99951 + 50) / 100.0 AS DECIMAL(12,2)),             -- 0.50 .. 1000.00
                CAST(r.r7 % 501 AS INT),                                        -- Stock 0 .. 500
                CAST(5 + r.r8 % 46 AS INT),                                     -- StockMinimo 5 .. 50
                CAST(CASE WHEN r.r9 % 20 = 0 THEN 0 ELSE 1 END AS BIT),         -- ~5 % inactivos
                DATEADD(MINUTE, CAST(r.r10 % 432000 AS INT),
                        CAST('2026-01-01T00:00:00' AS DATETIME2(0))),           -- ene-oct 2026
                NULL
            FROM numeros AS nu
            CROSS APPLY (SELECT HASHBYTES('SHA2_512', CONCAT(@Semilla, '|', nu.n)) AS hb) AS h
            CROSS APPLY (
                SELECT  CAST(SUBSTRING(h.hb,  1, 4) AS BIGINT) AS r1,
                        CAST(SUBSTRING(h.hb,  5, 4) AS BIGINT) AS r2,
                        CAST(SUBSTRING(h.hb,  9, 4) AS BIGINT) AS r3,
                        CAST(SUBSTRING(h.hb, 13, 4) AS BIGINT) AS r4,
                        CAST(SUBSTRING(h.hb, 17, 4) AS BIGINT) AS r5,
                        CAST(SUBSTRING(h.hb, 21, 4) AS BIGINT) AS r6,
                        CAST(SUBSTRING(h.hb, 25, 4) AS BIGINT) AS r7,
                        CAST(SUBSTRING(h.hb, 29, 4) AS BIGINT) AS r8,
                        CAST(SUBSTRING(h.hb, 33, 4) AS BIGINT) AS r9,
                        CAST(SUBSTRING(h.hb, 37, 4) AS BIGINT) AS r10
            ) AS r
            ORDER BY nu.n;

            SET IDENTITY_INSERT dbo.Productos OFF;

            /* 4. Ajustar contadores de identidad
                  - Productos: el próximo creado por la API será @Cantidad + 1
                  - Movimientos: reinicia en 1 (solo si la tabla ya se usó) */
            DBCC CHECKIDENT ('dbo.Productos', RESEED, @Cantidad) WITH NO_INFOMSGS;

            IF (SELECT last_value FROM sys.identity_columns
                WHERE object_id = OBJECT_ID(N'dbo.MovimientosInventario')) IS NOT NULL
                DBCC CHECKIDENT ('dbo.MovimientosInventario', RESEED, 0) WITH NO_INFOMSGS;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH

    /* 5. Misma condición física para todas las series */
    ALTER INDEX ALL ON dbo.Productos REBUILD;
    ALTER INDEX ALL ON dbo.MovimientosInventario REBUILD;
    UPDATE STATISTICS dbo.Categorias WITH FULLSCAN;

    SELECT
        @Cantidad                                        AS ProductosGenerados,
        @Semilla                                         AS Semilla,
        (SELECT COUNT(*) FROM dbo.Productos)             AS TotalProductos,
        (SELECT COUNT(*) FROM dbo.Categorias)            AS TotalCategorias,
        DATEDIFF(MILLISECOND, @Inicio, SYSDATETIME())    AS DuracionMs;
END
GO

/* ---------------------------------------------------------------------
   sp_LimpiarCache
   Condición controlada del experimento: "Caché de SQL Server reiniciada
   entre series". Ejecutar ANTES de cada serie de mediciones.
   Requiere rol sysadmin (DBCC DROPCLEANBUFFERS): ejecutar desde SSMS
   con el usuario administrador, NO desde la API.
   --------------------------------------------------------------------- */
CREATE OR ALTER PROCEDURE dbo.sp_LimpiarCache
AS
BEGIN
    SET NOCOUNT ON;

    CHECKPOINT;                                             -- escribe páginas sucias a disco
    DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS;                 -- vacía el buffer pool
    ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;  -- planes de esta BD

    PRINT 'Caché de datos y de planes de InventarioDB limpiada.';
END
GO

/* ---------------------------------------------------------------------
   Carga inicial de categorías
   --------------------------------------------------------------------- */
EXEC dbo.sp_RestablecerCategorias;
GO

PRINT 'Script 02 completado: vistas y procedimientos creados.';
GO