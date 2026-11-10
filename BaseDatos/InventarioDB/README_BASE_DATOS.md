# Base de datos `InventarioDB` — SQL Server 2022

Base de datos del sistema de inventario que consumen la **API REST (Spring Boot / OpenJDK 21)**, la **aplicación web** y la **aplicación Android (Kotlin + Retrofit)**.

> La web y la app **nunca** se conectan a la base de datos: solo la API. La web y Android hablan únicamente con la API por HTTP.

```
[Web Chrome]  ──HTTP/JSON──┐
                           ├──►  API REST (Spring Boot)  ──JDBC──►  SQL Server · InventarioDB
[Android Retrofit] ─HTTP───┘
```

---

## 1. Instalación (una sola vez, en la máquina servidor)

1. Instalar **SQL Server 2022 Developer** y **SSMS**.
2. Activar **autenticación mixta** (SSMS → clic derecho en el servidor → Propiedades → Seguridad → *SQL Server and Windows Authentication mode*) y reiniciar el servicio.
3. Activar **TCP/IP en el puerto 1433** (SQL Server Configuration Manager → Protocols for MSSQLSERVER → TCP/IP → Enabled) y reiniciar el servicio.
4. Abrir en SSMS y ejecutar **en este orden**, conectado como `sa` o administrador de Windows:

| Orden | Archivo | Qué hace |
|---|---|---|
| 1 | `01_crear_base_datos.sql` | Crea `InventarioDB`, tablas, restricciones, índices y el usuario `inventario_api` |
| 2 | `02_procedimientos_vistas.sql` | Crea vistas, procedimientos y carga las 10 categorías |
| 3 | `03_datos_prueba.sql` | Carga 1.000 productos sintéticos y muestra consultas de verificación |

> ⚠️ El script 01 **elimina y recrea** `InventarioDB` si ya existe.
> ⚠️ Cambien la contraseña de `inventario_api` en el script 01 y compártanla por privado, **no** la suban a GitHub.

**Verificación entre compañeros:** el script 03 muestra un valor `HuellaDatos`. Si todos obtienen el mismo número, todos tienen exactamente los mismos datos.

---

## 2. Conexión desde la API (Spring Boot)

**Dependencia (Maven):**

```xml
<dependency>
    <groupId>com.microsoft.sqlserver</groupId>
    <artifactId>mssql-jdbc</artifactId>
    <scope>runtime</scope>
</dependency>
```

**`application.properties`:**

```properties
spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=InventarioDB;encrypt=true;trustServerCertificate=true
spring.datasource.username=inventario_api
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

# MUY IMPORTANTE: la estructura la crean los scripts SQL, Hibernate NO debe modificarla
spring.jpa.hibernate.ddl-auto=none
spring.jpa.open-in-view=false
spring.jpa.show-sql=false

# Que los nombres de las columnas se respeten tal cual (ProductoId, PrecioUnitario, ...)
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl

# Fechas en formato ISO-8601 en el JSON
spring.jackson.serialization.write-dates-as-timestamps=false
```

La contraseña se pasa como variable de entorno: `DB_PASSWORD=... ./mvnw spring-boot:run`.

- `encrypt=true;trustServerCertificate=true` evita el error de certificado SSL típico con SQL Server local.
- Si usan una instancia con nombre (ej. `SQLEXPRESS`): `jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=...` y activar el servicio *SQL Server Browser*.

---

## 3. Modelo de datos

```
Categorias 1 ──── * Productos 1 ──── * MovimientosInventario
                                       (ON DELETE CASCADE)

Mediciones   (independiente: resultados del experimento)
```

### `dbo.Categorias`

| Columna | Tipo SQL | Tipo Java | Notas |
|---|---|---|---|
| CategoriaId | INT IDENTITY (PK) | `Integer` | `@GeneratedValue(strategy = GenerationType.IDENTITY)` |
| Nombre | NVARCHAR(100) | `String` | Obligatorio, único |
| Descripcion | NVARCHAR(255) | `String` | Opcional |
| Activo | BIT | `Boolean` | Por defecto 1 |
| FechaCreacion | DATETIME2(0) | `LocalDateTime` | La pone la BD → `insertable = false, updatable = false` |

IDs 1–10 son las categorías base (Electrónica, Computación, Papelería, Limpieza, Ferretería, Alimentos, Bebidas, Hogar, Mobiliario, Telefonía).

### `dbo.Productos` (entidad del experimento CRUD)

| Columna | Tipo SQL | Tipo Java | Notas |
|---|---|---|---|
| ProductoId | INT IDENTITY (PK) | `Integer` | IDENTITY |
| Codigo | VARCHAR(30) | `String` | SKU, obligatorio y **único** |
| Nombre | NVARCHAR(150) | `String` | Obligatorio |
| Descripcion | NVARCHAR(500) | `String` | Opcional |
| CategoriaId | INT (FK) | `Integer` | Debe existir en Categorias |
| PrecioUnitario | DECIMAL(12,2) | `BigDecimal` | ≥ 0 |
| Stock | INT | `Integer` | ≥ 0. Por defecto 0 |
| StockMinimo | INT | `Integer` | ≥ 0. Por defecto 0 |
| Activo | BIT | `Boolean` | Por defecto 1 |
| FechaCreacion | DATETIME2(0) | `LocalDateTime` | La pone la BD → `insertable = false, updatable = false` |
| FechaActualizacion | DATETIME2(0) | `LocalDateTime` | La API la asigna en PUT (`LocalDateTime.now()`) |

**Vista `dbo.vw_ProductosDetalle`**: lo mismo + `CategoriaNombre` y `BajoStock` (true si `Stock <= StockMinimo`). Útil para pantallas de listado.

### `dbo.MovimientosInventario`

| Columna | Tipo SQL | Tipo Java |
|---|---|---|
| MovimientoId | BIGINT IDENTITY (PK) | `Long` |
| ProductoId | INT (FK) | `Integer` |
| TipoMovimiento | VARCHAR(10): `ENTRADA` / `SALIDA` / `AJUSTE` | `String` |
| Cantidad | INT | `Integer` |
| StockAnterior / StockResultante | INT | `Integer` |
| Comentario | NVARCHAR(255) | `String` |
| FechaMovimiento | DATETIME2(0) | `LocalDateTime` |

**No insertar directamente**: usar siempre el procedimiento `dbo.sp_RegistrarMovimiento`, que valida y actualiza el stock en la misma transacción.

### `dbo.Mediciones` (resultados del experimento)

| Columna | Tipo | Valores permitidos |
|---|---|---|
| MedicionId | BIGINT IDENTITY | — |
| Plataforma | VARCHAR(10) | `WEB`, `ANDROID` |
| Volumen | INT | `1000`, `10000`, `100000` |
| Operacion | VARCHAR(10) | `CREATE`, `READ`, `UPDATE`, `DELETE` |
| Repeticion | TINYINT | 1–10 |
| EsCalentamiento | BIT | 1 = calentamiento (no se analiza) |
| TiempoRespuestaMs | DECIMAL(12,3) | ms (`performance.now()` / `System.nanoTime()`) |
| MemoriaMB | DECIMAL(10,3) | MB (`performance.memory` / Android Profiler), opcional |
| CodigoHttp | SMALLINT | ej. 200, 201, 204 |
| Dispositivo | NVARCHAR(100) | ej. `Chrome 128`, `Pixel 6 Android 14` |
| Notas | NVARCHAR(255) | opcional |
| FechaRegistro | DATETIME2(3) | la pone la BD |

Vistas: `vw_ResumenMediciones` (media, mediana, desviación, CV por celda) y `vw_ProgresoExperimento` (cuántas repeticiones lleva cada una de las 24 celdas).

---

## 4. Contrato JSON acordado (web y Android deben usar estos nombres)

Nombres en **camelCase**, fechas ISO-8601, precios como número.

**Producto (respuesta):**

```json
{
  "productoId": 1,
  "codigo": "PRD-000001",
  "nombre": "Kit Premium Orion M-0421",
  "descripcion": "Producto sintético de prueba n.° 1. ...",
  "categoriaId": 3,
  "categoriaNombre": "Papelería",
  "precioUnitario": 245.90,
  "stock": 120,
  "stockMinimo": 15,
  "activo": true,
  "fechaCreacion": "2026-04-12T10:31:00",
  "fechaActualizacion": null
}
```

**Producto (cuerpo de POST / PUT):** `codigo`, `nombre`, `descripcion`, `categoriaId`, `precioUnitario`, `stock` (solo en POST), `stockMinimo`, `activo`.

**Movimiento (POST):** `{ "productoId": 1, "tipoMovimiento": "ENTRADA", "cantidad": 10, "comentario": "Compra" }`

**Medición (POST):** `{ "plataforma": "WEB", "volumen": 1000, "operacion": "READ", "repeticion": 1, "esCalentamiento": false, "tiempoRespuestaMs": 152.374, "memoriaMB": 38.21, "codigoHttp": 200, "dispositivo": "Chrome 128" }`

---

## 5. Endpoints sugeridos y su relación con la BD

| Método | Endpoint | BD | Respuesta |
|---|---|---|---|
| GET | `/api/productos` | `SELECT` de `vw_ProductosDetalle` (**todos**, sin paginar: es la operación READ del experimento) | 200 |
| GET | `/api/productos?page=0&size=50` | Igual, paginado (para la interfaz) | 200 |
| GET | `/api/productos/{id}` | `SELECT ... WHERE ProductoId = ?` | 200 / 404 |
| POST | `/api/productos` | `INSERT` en Productos (**CREATE**) | 201 / 400 / 409 |
| PUT | `/api/productos/{id}` | `UPDATE` de Productos, no cambia `Stock` (**UPDATE**) | 200 / 404 |
| DELETE | `/api/productos/{id}` | `DELETE` de Productos; borra sus movimientos en cascada (**DELETE**) | 204 / 404 |
| GET | `/api/categorias` | `SELECT` de Categorias | 200 |
| POST | `/api/movimientos` | `EXEC dbo.sp_RegistrarMovimiento` | 201 / 400 / 404 / 409 |
| GET | `/api/productos/{id}/movimientos` | `SELECT` de MovimientosInventario | 200 |
| POST | `/api/mediciones` | `INSERT` en Mediciones (acepta un objeto o una lista) | 201 |
| GET | `/api/mediciones/resumen` | `SELECT * FROM vw_ResumenMediciones` | 200 |

### Errores que la API debe traducir a HTTP

| Origen | Código SQL Server | HTTP |
|---|---|---|
| `Codigo` de producto repetido (UNIQUE) | 2627 / 2601 | 409 Conflict |
| `CategoriaId` inexistente (FK) | 547 | 400 Bad Request |
| Precio o stock negativos (CHECK) | 547 | 400 Bad Request |
| `sp_RegistrarMovimiento`: producto no existe | 50001 | 404 Not Found |
| `sp_RegistrarMovimiento`: tipo o cantidad inválidos | 50002 | 400 Bad Request |
| `sp_RegistrarMovimiento`: stock insuficiente | 50003 | 409 Conflict |
| `sp_RegistrarMovimiento`: producto inactivo | 50004 | 409 Conflict |

En Spring el error llega envuelto: buscar la causa `com.microsoft.sqlserver.jdbc.SQLServerException` y leer `getErrorCode()`.

**Llamar al procedimiento con `JdbcTemplate`:**

```java
Map<String, Object> mov = jdbcTemplate.queryForMap(
    "EXEC dbo.sp_RegistrarMovimiento @ProductoId = ?, @TipoMovimiento = ?, @Cantidad = ?, @Comentario = ?",
    dto.productoId(), dto.tipoMovimiento(), dto.cantidad(), dto.comentario());
```

---

## 6. Flujo del experimento (lo ejecuta el admin desde SSMS)

Antes de **cada serie** (una plataforma + un volumen):

```sql
EXEC dbo.sp_GenerarDatosPrueba @Cantidad = 10000;   -- 1000 / 10000 / 100000, semilla 42
EXEC dbo.sp_LimpiarCache;                           -- "caché de SQL Server reiniciada entre series"
```

- `sp_GenerarDatosPrueba` borra productos y movimientos (**no** borra `Mediciones`) y genera los productos con `ProductoId` = 1…N. Con la misma cantidad y semilla los datos son idénticos siempre.
- El siguiente producto que cree la API tendrá `ProductoId = N + 1`.
- Ambos procedimientos requieren permisos de administrador: **no** llamarlos desde la API.

Recomendaciones para que web y Android hagan exactamente lo mismo:

| Operación | Qué enviar en cada repetición |
|---|---|
| CREATE | Producto con `codigo` único, ej. `WEB-C-01`, `AND-C-01`… y `categoriaId` entre 1 y 10 |
| READ | `GET /api/productos` (devuelve los N registros) |
| UPDATE | `PUT /api/productos/{id}` siempre sobre el mismo id, ej. `N/2` |
| DELETE | Un id distinto por repetición: 1, 2, 3, … 15 (5 calentamientos + 10 válidas) |

Seguimiento y exportación:

```sql
SELECT * FROM dbo.vw_ProgresoExperimento ORDER BY Plataforma, Volumen, Operacion;
SELECT * FROM dbo.vw_ResumenMediciones   ORDER BY Plataforma, Volumen, Operacion;
SELECT * FROM dbo.Mediciones WHERE EsCalentamiento = 0;   -- exportar a CSV para pandas
```

> Para no alterar los tiempos medidos, la web y la app pueden guardar las mediciones en memoria y enviarlas en un solo `POST /api/mediciones` al terminar la serie.

---

## 7. Problemas frecuentes

| Síntoma | Solución |
|---|---|
| `Login failed for user 'inventario_api'` | Activar autenticación mixta y reiniciar el servicio |
| `The TCP/IP connection to the host localhost, port 1433 has failed` | Activar TCP/IP en Configuration Manager y reiniciar; revisar el firewall |
| `PKIX path building failed` / error SSL | Agregar `trustServerCertificate=true` a la URL |
| Hibernate intenta crear o modificar tablas | `spring.jpa.hibernate.ddl-auto=none` |
| `Invalid column name 'producto_id'` | Usar `PhysicalNamingStrategyStandardImpl` o `@Column(name = "ProductoId")` |
| `The DELETE statement conflicted with the REFERENCE constraint` al ejecutar `sp_RestablecerCategorias` | Hay productos en categorías creadas en pruebas: ejecutar `sp_GenerarDatosPrueba` |
| Web: error CORS | Configurar `@CrossOrigin` o `WebMvcConfigurer` en la API (no es un problema de la BD) |
| Android no llega a la API por HTTP | Usar la IP LAN del servidor (no `localhost`) y permitir tráfico en texto claro (`usesCleartextTraffic`) |
