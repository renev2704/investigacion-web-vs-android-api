/* =====================================================================
   SISTEMA DE INVENTARIO - BASE DE DATOS (SQL Server 2022)
   Script 03: carga de datos sintéticos y verificación.

   Ejecutar después de 02_procedimientos_vistas.sql, con usuario admin.
   ===================================================================== */

USE InventarioDB;
GO

/* ---------------------------------------------------------------------
   1. Carga inicial para desarrollo: 1.000 productos (semilla 42)
   --------------------------------------------------------------------- */
EXEC dbo.sp_GenerarDatosPrueba @Cantidad = 1000, @Semilla = 42;
GO

/* ---------------------------------------------------------------------
   2. Verificación rápida
   --------------------------------------------------------------------- */
-- Debe devolver 1000 productos y 10 categorías
SELECT
    (SELECT COUNT(*) FROM dbo.Productos)              AS Productos,
    (SELECT COUNT(*) FROM dbo.Categorias)             AS Categorias,
    (SELECT COUNT(*) FROM dbo.MovimientosInventario)  AS Movimientos;

-- Primeros 10 productos (deben ser idénticos en todas las máquinas del equipo)
SELECT TOP (10) ProductoId, Codigo, Nombre, CategoriaNombre, PrecioUnitario, Stock, StockMinimo, BajoStock, Activo
FROM dbo.vw_ProductosDetalle
ORDER BY ProductoId;

-- Huella de reproducibilidad: comparen este número entre compañeros.
-- Si coincide, todos tienen exactamente los mismos datos.
SELECT CHECKSUM_AGG(CHECKSUM(ProductoId, Codigo, Nombre, CategoriaId, PrecioUnitario,
                             Stock, StockMinimo, Activo, FechaCreacion)) AS HuellaDatos
FROM dbo.Productos;

-- Distribución por categoría
SELECT c.CategoriaId, c.Nombre, COUNT(p.ProductoId) AS Productos
FROM dbo.Categorias c
LEFT JOIN dbo.Productos p ON p.CategoriaId = c.CategoriaId
GROUP BY c.CategoriaId, c.Nombre
ORDER BY c.CategoriaId;
GO

/* ---------------------------------------------------------------------
   3. Prueba del procedimiento de movimientos (se revierte al final)
   --------------------------------------------------------------------- */
BEGIN TRANSACTION;
    EXEC dbo.sp_RegistrarMovimiento @ProductoId = 1, @TipoMovimiento = 'ENTRADA', @Cantidad = 25, @Comentario = N'Prueba de entrada';
    EXEC dbo.sp_RegistrarMovimiento @ProductoId = 1, @TipoMovimiento = 'SALIDA',  @Cantidad = 5,  @Comentario = N'Prueba de salida';
    SELECT ProductoId, Stock FROM dbo.Productos WHERE ProductoId = 1;
ROLLBACK TRANSACTION;
GO

/* =====================================================================
   4. PROCEDIMIENTO PARA CADA SERIE DEL EXPERIMENTO (referencia)
   ---------------------------------------------------------------------
   Antes de medir una celda/serie con un volumen dado:

       EXEC dbo.sp_GenerarDatosPrueba @Cantidad = 1000;    -- o 10000 / 100000
       EXEC dbo.sp_LimpiarCache;

   Luego ejecutar desde la web o la app: 5 calentamientos + 10 repeticiones.
   Volver a generar los datos antes de cada serie, porque CREATE y DELETE
   modifican la tabla y las series deben partir de los mismos datos.

   Consultas de seguimiento:
       SELECT * FROM dbo.vw_ProgresoExperimento ORDER BY Plataforma, Volumen, Operacion;
       SELECT * FROM dbo.vw_ResumenMediciones   ORDER BY Plataforma, Volumen, Operacion;

   Ejemplo de registro de una medición (lo normal es que lo haga la API
   con POST /api/mediciones al terminar cada serie):

       INSERT INTO dbo.Mediciones
           (Plataforma, Volumen, Operacion, Repeticion, EsCalentamiento,
            TiempoRespuestaMs, MemoriaMB, CodigoHttp, Dispositivo)
       VALUES ('WEB', 1000, 'READ', 1, 0, 152.374, 38.210, 200, N'Chrome 128');

   Exportar resultados para Python (pandas):
       SELECT * FROM dbo.Mediciones WHERE EsCalentamiento = 0 ORDER BY MedicionId;
   ===================================================================== */

PRINT 'Script 03 completado: datos de prueba cargados.';
GO