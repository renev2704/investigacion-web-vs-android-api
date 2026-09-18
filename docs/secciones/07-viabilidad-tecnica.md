# Viabilidad Técnica
## Comparación de Rendimiento Web y Android Consumiendo API REST

**Conclusión:** **PROYECTO VIABLE** | Duración: 18 semanas | Equipo: 6 personas | Costo: $0 USD

---

## Hardware y Software

| Aspecto | Especificación |
|--------|----------------|
| **RAM** | 16 GB mínimo (4 GB SQL Server + 3 GB ASP.NET + 4 GB Android Studio) |
| **Procesador** | 4+ núcleos @ 2.5 GHz |
| **Disco SSD** | 20-30 GB (SDK Android 12 GB, proyectos 3-5 GB, datos 2-5 GB) |
| **Herramientas** | ASP.NET Core 8, React, Kotlin, SQL Server Dev Edition, Docker - **TODAS GRATUITAS** |
| **Base de Datos** | SQL Server 2022 Developer Edition (gratuita) o Docker con límite 2 GB |

**Alternativas sin impacto:**
- **8 GB RAM:** Distribuir en sesiones separadas; Android Studio en dispositivo físico
- **SQL Server:** Docker con `mem_limit: 1.5g` O SQL Server Express (10 GB máx)
- **Android:** Emulador ligero ó dispositivo físico (lab UTEC)

---

## Datos y Riesgos

**Origen datos:** Dataset sintético generado (Python + Faker). No requiere datos reales.
- 3 volúmenes: 1,000 | 10,000 | 100,000 registros
- Generación: 5s (1k) a 30s (100k)

**Riesgos principales y mitigación:**

| Riesgo | Mitigación |
|--------|-----------|
| Android Studio >4GB en máquina 8GB | Usar dispositivo físico o emulador en PC remota |
| SQL Server consume mucha memoria | Limitar Docker a 1.5 GB; usar Express Edition |
| Compilación Kotlin tarda >5 min | Gradle daemon; SSD rápido; compilación incremental |
| Dataset 100k causa timeout | Implementar paginación (100 registros/página); reducir a 50k si es necesario |
| Medición memoria Android imprecisa | Android Profiler + adb shell dumpsys meminfo |

---

## Arquitectura y Metodología

```
Cliente Web (React) ──────┐
                          ├─→ API REST (ASP.NET Core) ─→ SQL Server
Cliente Android (Kotlin) ─┘

Pruebas: 2 plataformas × 3 volúmenes × 5 operaciones (CRUD+LIST) × 3 configuraciones × 10 repeticiones = 900 pruebas
Análisis: Estadística descriptiva, t-test, ANOVA, gráficas comparativas
```

**Endpoints API:**
```
GET/POST/PUT/DELETE /api/v1/productos
GET /api/v1/productos?page=1&pageSize=100
Autenticación: JWT
```

**Instrumentación:** Logging de tiempo/memoria en backend, Performance API en web, Android Profiler en móvil.

---

## Cronograma y Entregables

| Fase | Duración | Hitos |
|------|----------|-------|
| Setup | 2 sem | Ambiente + repos |
| Backend + BD | 5 sem | API funcional + dataset |
| Web + Android | 5 sem | Clientes integrados |
| Instrumentación | 2 sem | Métricas en todos |
| Pruebas + Análisis | 4 sem | 900 pruebas, resultados |

**Entregables finales:**
- Informe técnico (metodología, resultados, análisis estadístico)
- Código fuente comentado (GitHub)
- Dataset y resultados CSV/JSON
- Gráficas comparativas (tiempo vs. volumen, memoria, CPU)
- Respuestas a preguntas de investigación con p-values

---

## Conclusión

| Factor | Viabilidad                                   |
|--------|----------------------------------------------|
| Técnica | ✅ Stack maduro (ASP.NET, React, Kotlin)     |
| Económica | ✅ $0 licencias; solo hardware estándar      |
| Temporal | ✅ 18 semanas con equipo de 6                |
| Recursos | ✅ Estudiantes UTEC tienen skills necesarios |
| Hardware | ✅ Máquinas estándar (16 GB suficiente)      |

**Riesgo global:** 85-90% de probabilidad de éxito. Amenazas principales solucionables (gestión de equipo, device availability).