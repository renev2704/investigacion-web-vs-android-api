# 🔧 API REST - Sistema de Inventario

Backend del sistema de inventario desarrollado con **Java 21**, **Spring Boot 3.3** y **SQL Server 2022**. Expone los endpoints REST que consumen la aplicación web (HTML/JS) y la aplicación Android (Kotlin + Retrofit).

---

## 📋 Requisitos previos

Antes de ejecutar este proyecto, asegúrate de tener instalado:

| Herramienta | Versión mínima | Notas |
|---|---|---|
| **JDK (Java)** | 21 | Verifica con `java -version` |
| **Maven** | 3.9+ | O usa el wrapper `mvnw` incluido |
| **SQL Server** | 2022 | Con autenticación mixta activada |
| **SSMS** | Cualquiera reciente | Para administrar la base de datos |
| **IDE** | IntelliJ IDEA | Recomendado (Community o Ultimate) |

---

## 🗄️ 1. Configurar la Base de Datos

Antes de arrancar la API, **la base de datos debe existir**. Sigue estos pasos:

1. Abre **SQL Server Management Studio (SSMS)**.
2. Activa la **autenticación mixta**:
    - Clic derecho en el servidor → **Propiedades** → **Seguridad** → *SQL Server and Windows Authentication mode*.
    - Reinicia el servicio de SQL Server.
3. Habilita **TCP/IP** en el puerto **1433**:
    - Abre `SQLServerManager16.msc` (SQL Server Configuration Manager).
    - Ve a **SQL Server Network Configuration → Protocols for [TU_INSTANCIA]**.
    - Habilita **TCP/IP**.
    - Doble clic en TCP/IP → pestaña **IP Addresses** → sección **IP All**:
        - **TCP Dynamic Ports**: dejar vacío.
        - **TCP Port**: `1433`.
    - Reinicia el servicio **SQL Server (TU_INSTANCIA)**.
4. Ejecuta los scripts SQL **en este orden**:
   
   01_crear_base_datos.sql

   02_procedimientos_vistas.sql

   03_datos_prueba.sql

> ⚠️ El script `01` **elimina y recrea** la base de datos si ya existe.

---

## ⚙️ 2. Configurar la conexión en la API

Abre el archivo: api/src/main/resources/application.properties



Y edita las siguientes líneas con tus credenciales:


spring.datasource.url=jdbc:sqlserver://localhost:1433;databaseName=InventarioDB;encrypt=true;trustServerCertificate=true
spring.datasource.username=inventario_api
spring.datasource.password=TU_CONTRASEÑA_AQUI

💡 Nota: Si usas una instancia con nombre (ej. SQLEXPRESS), consulta la sección "Solución de problemas".

## 3. Ejecutar la API
Opción A: Desde IntelliJ IDEA (Recomendado)
Abre el archivo pom.xml con IntelliJ (File → Open → selecciona pom.xml).

Espera a que Maven descargue las dependencias.

Abre el archivo ApiInventarioApplication.java y haz clic en el botón ▶️ Run.

La API estará disponible en: http://localhost:8080


## 4. Verificar que funciona
   Abre tu navegador o Postman y prueba:


GET http://localhost:8080/api/productos
Deberías recibir un JSON con los productos de la base de datos.
