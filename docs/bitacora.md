# 📓 Bitácora del Proyecto

**Proyecto:** Comparación del rendimiento web y Android al consumir una API REST para un sistema de inventario con SQL Server

**Integrantes:** 

| No. | Nombre Completo | N° Carnet |
|---|---|---|
| 1 | Diego Alberto Chicas Martinez | 25-1005-2023 |
| 2 | José David Grande Lorenzana | 25-4832-2022 | 
| 3 | Alejandra Carolina Guillen Campos | 27-1517-2025 |
| 4 | Nelson Eduardo Ramirez Ramirez | | |
| 5 | Miguel Angel Rivera Lopez | 25-0948-2023 |
| 6 | René Daniel Ventura Sibrian | 27-0417-2025 |  

**Periodo registrado:** Últimas 2 semanas (definición del tema hasta elaboración de referencias)

---

## Actividad 1 — Definición del tema

**Fecha:** [09/Sep/2026]

**Descripción:**
Se eligió el tema del proyecto orientado a comparar el rendimiento entre un cliente web y un cliente Android al consumir una misma API REST conectada a SQL Server en un sistema de inventario.

**Decisiones tomadas:**
- Enfocar el estudio en dos métricas: **tiempo de respuesta** y **consumo de memoria**.
- Usar como base teórica el modelo **ISO/IEC 25010**, específicamente la característica de *Eficiencia de desempeño*.

**Observaciones:**
- Se descartaron otros temas por falta de antecedentes comparables o por no contar con las herramientas necesarias.

---

## Actividad 2 — Redacción del planteamiento del problema

**Fecha:** [14/Sep/2026]

**Descripción:**
Se redactó el planteamiento del problema justificando la necesidad de comparar el rendimiento entre ambos clientes bajo condiciones equivalentes.

**Trabajo realizado:**
- Revisión de antecedentes: Kaczmarczyk et al. (2022) y Pratama et al. (2025).
- Redacción del contexto: uso de APIs REST en sistemas de inventario y diferencias de rendimiento entre plataformas.
- Identificación del vacío: los estudios previos usan tecnologías y escenarios distintos.

**Decisiones tomadas:**
- Se definieron los volúmenes de prueba: **1.000, 10.000 y 100.000 registros**.
- Se establecieron **10 ejecuciones por combinación** para obtener promedios comparables.

---

## Actividad 3 — Formulación de la pregunta de investigación

**Fecha:** [14/Sep/2026]

**Descripción:**
Se formuló la pregunta principal y las preguntas secundarias que guiarán la investigación.

**Pregunta principal:**
¿Qué diferencias existen en el tiempo de respuesta y el consumo de memoria entre un cliente web y un cliente Android al consumir una API REST conectada a SQL Server, al ejecutar operaciones CRUD sobre conjuntos de 1.000, 10.000 y 100.000 registros, considerando el promedio de 10 ejecuciones por cada combinación?

**Preguntas secundarias:**
1. ¿Cómo varía la diferencia entre web y Android según el tipo de operación (lectura vs. escritura)?
2. ¿Qué configuración del cliente (caché, compresión, paginación) reduce la brecha observada?
3. ¿A partir de qué volumen de registros la diferencia se vuelve significativa en términos prácticos?

---

## Actividad 4 — Delimitación del problema

**Fecha:** [15/Sep/2026]

**Descripción:**
Se delimitó el alcance del proyecto en cuatro dimensiones.

**Trabajo realizado:**
- **Teórica:** basada en ISO/IEC 25010 (eficiencia de desempeño).
- **Temporal:** 4 semanas (semana 8 a 11 del ciclo 02-2026).
- **Espacial:** 5 endpoints CRUD del catálogo de productos y existencias.
- **Tecnológica:** SQL Server 2022, Java 21 + Spring Boot 3.3, cliente web (HTML5/CSS3/JS + Chrome 128), cliente Android (Kotlin 2.0 + Retrofit 2.11, Android 14 API 34).

**Hardware de pruebas:**
- Servidor: Intel Core i5-11400, 16 GB RAM, Windows 11.
- Dispositivo móvil: Android 14, 8 GB RAM.

---

## Actividad 5 — Redacción de los objetivos

**Fecha:** [16/Sep/2026]

**Descripción:**
Se redactó el objetivo general y los objetivos específicos del proyecto.

**Objetivo general:**
Comparar el rendimiento (tiempo de respuesta y consumo de memoria) entre un cliente web y un cliente Android al consumir los mismos endpoints de una API REST conectada a SQL Server.

**Objetivos específicos:**
- Diseñar e implementar la API REST de inventario.
- Desarrollar los clientes web y Android funcionalmente equivalentes.
- Implementar la instrumentación para medir tiempo de respuesta y memoria.
- Ejecutar pruebas controladas con 10 repeticiones por combinación.
- Analizar estadísticamente los resultados.
- Formular recomendaciones de diseño para arquitecturas de doble canal.

---

## Actividad 6 — Redacción de la justificación

**Fecha:**  [16/Sep/2026]

**Descripción:**
Se redactó la justificación del proyecto desde tres perspectivas.

**Trabajo realizado:**
- **Técnica:** comparación de tiempo de respuesta y consumo de memoria como referencia para elegir plataforma.
- **Académica:** generación de datos comparativos mediante pruebas controladas.
- **Profesional:** utilidad para desarrolladores y organizaciones que implementen sistemas multiplataforma.

---

## Actividad 7 — Análisis de viabilidad técnica

**Fecha:** [16/Sep/2026]

**Descripción:**
Se evaluó la viabilidad técnica del proyecto considerando herramientas, hardware y riesgos.

**Trabajo realizado:**
- Verificación de herramientas gratuitas: SQL Server Developer/Express, OpenJDK, Chrome, Android Studio, Python (pandas/scipy).
- Confirmación del hardware disponible.
- Identificación de riesgos y planes alternos:
  - Diferencias de red → misma LAN con servidor local.
  - Medición no comparable de memoria → métricas separadas (performance.memory vs. Android Profiler).
  - Variabilidad por procesos en segundo plano → 10 repeticiones y desviación estándar.

**Conclusión:**
Ningún riesgo es alto → viabilidad técnica aprobada.

---

## Actividad 8 — Elaboración del cronograma

**Fecha:** [17/Sep/2026]

**Descripción:**
Se elaboró el cronograma de entregas del proyecto alineado a las fases de la investigación.

**Trabajo realizado:**
- Definición de las etapas: definición del tema, planteamiento, objetivos, justificación, viabilidad, implementación, pruebas, análisis y recomendaciones.
- Organización de las entregas parciales por semana.

---

## Actividad 9 — Elaboración de las referencias

**Fecha:** [17/Sep/2026]

**Descripción:**
Se recopilaron y formatearon las referencias bibliográficas en normas APA 7.

**Referencias elaboradas:**
- Android Developers. (s. f.). *Overview of memory management*.
- Chrome for Developers. (s. f.). *Network features reference*.
- International Organization for Standardization. (2011). *ISO/IEC 25010:2011*.
- Kaczmarczyk, A., Zając, P., & Zabierowski, W. (2022). *Energies, 15*(13), 4574.
- Pratama, B. M. H., Hanggara, B. T., & Putra, W. H. N. (2025). *Jurnal Pengembangan Teknologi Informasi dan Ilmu Komputer, 9*(4).

---

## 📌 Observaciones finales

- Se completó la fase de planificación del proyecto.
- La documentación quedó organizada y lista para las siguientes entregas.
- Próxima etapa: implementación de la API REST y los clientes web y Android.
