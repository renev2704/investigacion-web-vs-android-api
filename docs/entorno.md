# Entorno experimental

## Servidor
- CPU: Intel Core i5-11400 (6 núcleos, 12 hilos, 2.6 GHz)
- RAM: 16 GB DDR4
- SO: Windows 11 Pro (23H2, build 22631)
- Java: OpenJDK 21.0.2
- Spring Boot: 3.3.0
- SQL Server: 2022 Developer Edition (16.0.1000.6)
- Configuración SQL Server: max server memory = 8 GB, connection pool = 20

## Aplicación web
- Chrome 128.0.6613.85 (64 bits), perfil limpio sin extensiones
- Caché HTTP deshabilitada durante mediciones

## Aplicación Android
- Dispositivo: Android 14 (API 34), 8 GB RAM
- Kotlin 2.0.0, Retrofit 2.11.0, OkHttp 4.12.0
- minSdk 26, targetSdk 34
- Modo avión activado para llamadas/datos móviles; Wi-Fi local activo

## Red
- LAN local 192.168.1.0/24, latencia < 1 ms, ancho de banda 100 Mbps

## Script de generación de datos
- Ubicación: scripts/seed-data.sql
- Volúmenes: 1.000, 10.000, 100.000 registros
- Semilla fija para reproducibilidad
