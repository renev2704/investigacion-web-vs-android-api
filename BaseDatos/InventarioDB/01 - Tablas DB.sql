/* =====================================================================
   SISTEMA DE INVENTARIO - BASE DE DATOS (SQL Server 2022)
   Proyecto: Comparación del rendimiento Web vs Android consumiendo
             una API REST (Spring Boot) para un sistema de inventario.
   Equipo N.° 01 - Programación III - Sección 03

   Script 01: crea la base de datos, las tablas, las restricciones,
              los índices y el usuario de la API.

   Orden de ejecución:
     01_crear_base_datos.sql   (este archivo)
     02_procedimientos_vistas.sql
     03_datos_prueba.sql

   Ejecutar en SSMS / Azure Data Studio con un usuario administrador (sa).
   ===================================================================== */

USE master;
GO

/* ---------------------------------------------------------------------
   1. Base de datos
   (Si ya existe se elimina y se crea de nuevo: entorno de pruebas.)
   --------------------------------------------------------------------- */
IF DB_ID(N'InventarioDB') IS NOT NULL
BEGIN
    ALTER DATABASE InventarioDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE InventarioDB;
END
GO

CREATE DATABASE InventarioDB;
GO

-- Modelo de recuperación simple: evita que el log crezca durante las
-- cargas masivas de 100.000 registros (entorno de laboratorio).
ALTER DATABASE InventarioDB SET RECOVERY SIMPLE;
GO

USE InventarioDB;
GO

/* ---------------------------------------------------------------------
   2. Tabla Categorias
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Categorias
(
    CategoriaId     INT             IDENTITY(1,1)   NOT NULL,
    Nombre          NVARCHAR(100)                   NOT NULL,
    Descripcion     NVARCHAR(255)                   NULL,
    Activo          BIT                             NOT NULL CONSTRAINT DF_Categorias_Activo DEFAULT (1),
    FechaCreacion   DATETIME2(0)                    NOT NULL CONSTRAINT DF_Categorias_FechaCreacion DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_Categorias        PRIMARY KEY CLUSTERED (CategoriaId),
    CONSTRAINT UQ_Categorias_Nombre UNIQUE (Nombre)
);
GO

/* ---------------------------------------------------------------------
   3. Tabla Productos  (entidad principal del experimento CRUD)
   - Stock guarda la existencia actual del producto.
   - Codigo es el SKU visible para el usuario (único).
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Productos
(
    ProductoId          INT             IDENTITY(1,1)   NOT NULL,
    Codigo              VARCHAR(30)                     NOT NULL,
    Nombre              NVARCHAR(150)                   NOT NULL,
    Descripcion         NVARCHAR(500)                   NULL,
    CategoriaId         INT                             NOT NULL,
    PrecioUnitario      DECIMAL(12,2)                   NOT NULL,
    Stock               INT                             NOT NULL CONSTRAINT DF_Productos_Stock        DEFAULT (0),
    StockMinimo         INT                             NOT NULL CONSTRAINT DF_Productos_StockMinimo  DEFAULT (0),
    Activo              BIT                             NOT NULL CONSTRAINT DF_Productos_Activo       DEFAULT (1),
    FechaCreacion       DATETIME2(0)                    NOT NULL CONSTRAINT DF_Productos_FechaCreacion DEFAULT (SYSDATETIME()),
    FechaActualizacion  DATETIME2(0)                    NULL,

    CONSTRAINT PK_Productos             PRIMARY KEY CLUSTERED (ProductoId),
    CONSTRAINT UQ_Productos_Codigo      UNIQUE (Codigo),
    CONSTRAINT FK_Productos_Categorias  FOREIGN KEY (CategoriaId)
                                        REFERENCES dbo.Categorias (CategoriaId),
    CONSTRAINT CK_Productos_Precio      CHECK (PrecioUnitario >= 0),
    CONSTRAINT CK_Productos_Stock       CHECK (Stock >= 0),
    CONSTRAINT CK_Productos_StockMinimo CHECK (StockMinimo >= 0)
);
GO

-- Índices de apoyo para filtros y búsquedas desde la web/app
CREATE NONCLUSTERED INDEX IX_Productos_CategoriaId ON dbo.Productos (CategoriaId);
CREATE NONCLUSTERED INDEX IX_Productos_Nombre      ON dbo.Productos (Nombre);
GO

/* ---------------------------------------------------------------------
   4. Tabla MovimientosInventario  (entradas, salidas y ajustes de stock)
   - Se registra SIEMPRE mediante dbo.sp_RegistrarMovimiento, que
     actualiza el Stock del producto en la misma transacción.
   - ON DELETE CASCADE: al eliminar un producto (operación DELETE del
     experimento) se eliminan sus movimientos y no hay error de FK.
   --------------------------------------------------------------------- */
CREATE TABLE dbo.MovimientosInventario
(
    MovimientoId        BIGINT          IDENTITY(1,1)   NOT NULL,
    ProductoId          INT                             NOT NULL,
    TipoMovimiento      VARCHAR(10)                     NOT NULL,   -- ENTRADA | SALIDA | AJUSTE
    Cantidad            INT                             NOT NULL,
    StockAnterior       INT                             NOT NULL,
    StockResultante     INT                             NOT NULL,
    Comentario          NVARCHAR(255)                   NULL,
    FechaMovimiento     DATETIME2(0)                    NOT NULL CONSTRAINT DF_Movimientos_Fecha DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_MovimientosInventario PRIMARY KEY CLUSTERED (MovimientoId),
    CONSTRAINT FK_Movimientos_Productos FOREIGN KEY (ProductoId)
                                        REFERENCES dbo.Productos (ProductoId)
                                        ON DELETE CASCADE,
    CONSTRAINT CK_Movimientos_Tipo      CHECK (TipoMovimiento IN ('ENTRADA','SALIDA','AJUSTE')),
    -- ENTRADA/SALIDA usan cantidades positivas; AJUSTE puede ser + o - (no 0)
    CONSTRAINT CK_Movimientos_Cantidad  CHECK (
                                            (TipoMovimiento IN ('ENTRADA','SALIDA') AND Cantidad > 0)
                                         OR (TipoMovimiento = 'AJUSTE' AND Cantidad <> 0)
                                        ),
    CONSTRAINT CK_Movimientos_Resultante CHECK (StockResultante >= 0)
);
GO

CREATE NONCLUSTERED INDEX IX_Movimientos_Producto_Fecha
    ON dbo.MovimientosInventario (ProductoId, FechaMovimiento DESC);
GO

/* ---------------------------------------------------------------------
   5. Tabla Mediciones  (resultados del experimento de rendimiento)
   Cada fila = una unidad de análisis: una ejecución de una operación
   CRUD en una plataforma con un volumen de registros.
   Diseño: 2 plataformas x 3 volúmenes x 4 operaciones = 24 celdas,
           10 repeticiones registradas + 5 de calentamiento por celda.
   --------------------------------------------------------------------- */
CREATE TABLE dbo.Mediciones
(
    MedicionId          BIGINT          IDENTITY(1,1)   NOT NULL,
    Plataforma          VARCHAR(10)                     NOT NULL,   -- WEB | ANDROID
    Volumen             INT                             NOT NULL,   -- 1000 | 10000 | 100000
    Operacion           VARCHAR(10)                     NOT NULL,   -- CREATE | READ | UPDATE | DELETE
    Repeticion          TINYINT                         NOT NULL,   -- 1..10 (o 1..5 si es calentamiento)
    EsCalentamiento     BIT                             NOT NULL CONSTRAINT DF_Mediciones_Calentamiento DEFAULT (0),
    TiempoRespuestaMs   DECIMAL(12,3)                   NOT NULL,
    MemoriaMB           DECIMAL(10,3)                   NULL,
    CodigoHttp          SMALLINT                        NULL,
    Dispositivo         NVARCHAR(100)                   NULL,       -- ej. 'Chrome 128' / 'Pixel 6 - Android 14'
    Notas               NVARCHAR(255)                   NULL,
    FechaRegistro       DATETIME2(3)                    NOT NULL CONSTRAINT DF_Mediciones_Fecha DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_Mediciones            PRIMARY KEY CLUSTERED (MedicionId),
    CONSTRAINT CK_Mediciones_Plataforma CHECK (Plataforma IN ('WEB','ANDROID')),
    CONSTRAINT CK_Mediciones_Volumen    CHECK (Volumen IN (1000, 10000, 100000)),
    CONSTRAINT CK_Mediciones_Operacion  CHECK (Operacion IN ('CREATE','READ','UPDATE','DELETE')),
    CONSTRAINT CK_Mediciones_Repeticion CHECK (Repeticion BETWEEN 1 AND 10),
    CONSTRAINT CK_Mediciones_Tiempo     CHECK (TiempoRespuestaMs >= 0),
    CONSTRAINT CK_Mediciones_Memoria    CHECK (MemoriaMB IS NULL OR MemoriaMB >= 0)
);
GO

CREATE NONCLUSTERED INDEX IX_Mediciones_Celda
    ON dbo.Mediciones (Plataforma, Volumen, Operacion, EsCalentamiento)
    INCLUDE (TiempoRespuestaMs, MemoriaMB);
GO

/* ---------------------------------------------------------------------
   6. Usuario de la API (autenticación SQL Server)
   - Requiere que la instancia esté en modo de autenticación mixta.
   - CAMBIAR LA CONTRASEÑA antes de usar y compartirla por un medio
     privado (no subirla al repositorio).
   --------------------------------------------------------------------- */
USE master;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'inventario_api')
    CREATE LOGIN inventario_api
        WITH PASSWORD = N'Inventario#2026',
             DEFAULT_DATABASE = InventarioDB,
             CHECK_POLICY = ON;
GO

USE InventarioDB;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'inventario_api')
    CREATE USER inventario_api FOR LOGIN inventario_api;
GO

-- Lectura/escritura sobre las tablas + ejecución de procedimientos.
-- No tiene permisos para modificar el esquema.
ALTER ROLE db_datareader ADD MEMBER inventario_api;
ALTER ROLE db_datawriter ADD MEMBER inventario_api;
GRANT EXECUTE ON SCHEMA::dbo TO inventario_api;
GO

PRINT 'completado: InventarioDB creada.';
GO