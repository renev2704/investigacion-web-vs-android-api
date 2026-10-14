# Estado del arte

## Búsqueda y selección de antecedentes

Para identificar investigaciones relacionadas con el rendimiento de aplicaciones que consumen servicios web, se consideran estudios sobre aplicaciones móviles nativas e híbridas, bibliotecas de comunicación mediante REST API y herramientas para medir el tiempo de respuesta y el consumo de recursos. La búsqueda se orienta a trabajos con mediciones cuantitativas que permitan comparar una aplicación web y una aplicación Android bajo condiciones equivalentes.

Las fuentes de consulta incluyen revistas académicas, repositorios científicos y documentación técnica oficial, priorizando trabajos publicados entre 2021 y 2026, sin excluir investigaciones anteriores cuando aportan fundamentos relevantes.

### Cadenas de búsqueda propuestas

| Tema | Cadena de búsqueda | Base de datos | Fecha | Resultados | Seleccionados |
|---|---|---|---|---|---|
| Rendimiento web vs móvil | `("web application" OR "mobile application" OR Android) AND ("REST API" OR "RESTful API") AND ("performance comparison" OR "response time" OR "memory consumption")` | IEEE Xplore | 5 09 2026 | 127 | 6 |
| Android + REST + rendimiento | `(Android OR Kotlin) AND ("REST API") AND ("performance" OR "latency" OR "memory") AND (Retrofit OR OkHttp)` | ACM Digital Library | 5 09 2026 | 89 | 4 |
| SQL Server + API REST + rendimiento | `("SQL Server" OR "Microsoft SQL Server") AND ("REST API") AND ("CRUD" OR "inventory") AND ("performance evaluation" OR "benchmark")` | Scopus / ScienceDirect | 5 09 2026 | 45 | 3 |

Los criterios de inclusión son la relación directa con el rendimiento de aplicaciones, la disponibilidad de información sobre el método utilizado y la presencia de métricas o resultados verificables. Se excluyen los trabajos que no describen suficientemente su procedimiento, los documentos duplicados y las fuentes comerciales que no presentan evidencia comprobable.

## Matriz comparativa de antecedentes

| Autor y año | Objetivo | Método y entorno | Hallazgo principal | Vacío detectado |
|---|---|---|---|---|
| Kaczmarczyk et al. (2022) | Comparar aplicaciones Android nativas e híbridas que procesan información mediante una REST API en escenarios de sensores BLE/Wi-Fi | Java 8 nativo vs. Ionic híbrido; red de sensores con BLE/Wi-Fi; medición de tiempos de construcción y respuesta | La app nativa construye 2× más rápido; responde 2× más rápido a la REST API, y la ventaja crece con el número de objetos en la respuesta; usa ~20% menos recursos de hardware | No incluye aplicación web; sin SQL Server; no es sistema de inventario; no compara consumo de memoria entre plataformas |
| Bauer (2025) | Comparar Kotlin Multiplatform, Flutter y nativo iOS/Android en rendimiento | Hardware controlado; peticiones HTTP GET RESTful, acceso a base de datos, renderizado UI, tareas intensivas de CPU | iOS nativo superior; Flutter fuerte en CPU pero ineficiente en memoria; Kotlin Multiplatform equilibrado pero complejo; Android nativo balanceado | Solo compara móvil; sin contraste con aplicación web; sin SQL Server; sin escenario de inventario |
| Santoso et al. (2025) | Comparar Retrofit, Ktor Client, OkHttp y Volley en la obtención de datos en Android | Peticiones HTTP POST/GET; entre 100 y 10,000 registros; medición de tiempo de respuesta, memoria y datos transmitidos | OkHttp responde más rápido; Retrofit es más eficiente en memoria; Ktor Client transmite menos datos; sin diferencias significativas en la recepción | Solo Android, sin contraste web; sin SQL Server; no es escenario CRUD de inventario |
| Pratama et al. (2025) | Comparar el rendimiento de las bibliotecas Retrofit y Volley en la obtención de datos mediante REST API | Pruebas con REST API; medición de tiempo de respuesta, uso de red y consumo de memoria | Diferencias medibles según la biblioteca y la configuración; Retrofit más eficiente en memoria, Volley mejor en tiempo de respuesta | Solo Android; sin contraste web; sin SQL Server; un solo volumen de datos |
| IEEE ICWS (2015) | Caracterizar diferencias de rendimiento entre app nativa y app web al consumir servicios RESTful | Análisis de trazas a nivel HTTP; GET, DELETE, PUT, POST; número de conexiones, tiempo de respuesta, consumo de datos | Las apps web no siempre son peores que las nativas; los patrones de uso difieren según el estilo arquitectónico; se proponen mejoras | El más cercano pero desactualizado (10 años); sin SQL Server; no es inventario; no mide memoria |
| REST vs GraphQL en móvil (2023) | Comparar REST y GraphQL en calidad de software desde aplicaciones móviles | Experimento computacional; eficiencia de rendimiento; 3 APIs (1 GraphQL, 2 REST) | GraphQL supera a REST en calidad de software desde móvil | Compara arquitecturas de API, no plataformas; solo móvil; sin contraste web; sin SQL Server |
| Kotlin vs Flutter vs React Native (2025) | Comparar tiempo de respuesta y uso de recursos en llamadas frecuentes a API | Llamadas frecuentes a API; medición de respuesta, CPU, memoria y renderizado | Kotlin nativo es el más rápido y estable; Flutter tiene baja latencia y renderizado fluido; React Native sufre por el puente JS | Compara frameworks móviles; sin aplicación web; sin SQL Server |
| Xamarin vs nativo (Universidad de Tartu) | Comparar velocidad de arranque y peticiones REST entre Xamarin y desarrollo nativo | Peticiones con arquitectura REST; inserción/lectura masiva en SQLite (10,000 registros) | La app nativa arranca ~2× más rápido; las peticiones REST son ~2× más rápidas; Xamarin usa ~20× más memoria que nativo | Compara frameworks, no web vs móvil; sin SQL Server; sin CRUD de inventario |

## Párrafos de síntesis por antecedente

**Kaczmarczyk et al. (2022):** Este estudio demuestra que las aplicaciones nativas superan a las híbridas en velocidad de construcción y respuesta a REST APIs, con una ventaja que se amplifica conforme crece el volumen de datos. Su aporte principal es evidenciar que la plataforma de ejecución influye directamente en el rendimiento al consumir servicios REST. Sin embargo, al no incluir una aplicación web como contraste, no permite determinar si esas diferencias son exclusivas de Android o comunes a cualquier cliente. Este vacío refuerza la necesidad de comparar web y Android bajo condiciones equivalentes.

**Bauer (2025):** Aporta una comparación controlada entre Kotlin Multiplatform, Flutter y desarrollo nativo en iOS y Android, midiendo peticiones HTTP, acceso a base de datos y renderizado. Sus resultados muestran que el rendimiento óptimo depende del tipo de tarea y que la memoria es un factor crítico diferenciador entre frameworks. No obstante, el estudio se limita al ecosistema móvil y omite cualquier contraste con aplicaciones web, lo que deja sin responder si una aplicación web podría igualar o superar el rendimiento observado.

**Santoso et al. (2025):** Compara cuatro bibliotecas de red en Android (Retrofit, Ktor Client, OkHttp y Volley) bajo volúmenes crecientes de datos, midiendo tiempo de respuesta, memoria y datos transmitidos. Su hallazgo principal es que no existe una biblioteca óptima para todas las métricas: OkHttp gana en velocidad, Retrofit en memoria y Ktor en eficiencia de red. Este antecedente es metodológicamente cercano al presente estudio por su diseño con volúmenes variables y múltiples métricas, pero se restringe a Android y no incorpora una aplicación web ni un backend SQL Server.

**Pratama et al. (2025):** Compara Retrofit y Volley en la obtención de datos mediante REST API, midiendo tiempo de respuesta, uso de red y consumo de memoria. Sus resultados confirman que la elección de biblioteca afecta el rendimiento, pero al centrarse en Android y en un único volumen de datos, no responde la pregunta sobre diferencias entre aplicación web y Android ni sobre cómo varía la brecha con el volumen de registros.

**IEEE ICWS (2015):** Es el antecedente más directamente relacionado con esta investigación, pues compara aplicaciones nativas y aplicaciones web al consumir servicios RESTful mediante análisis de trazas HTTP. Su hallazgo más relevante es que las aplicaciones web no siempre son inferiores a las nativas, lo que contradice la intuición común y justifica la necesidad de mediciones empíricas. No obstante, su antigüedad (10 años), la ausencia de SQL Server, la falta de un escenario de inventario y la omisión del consumo de memoria limitan su aplicabilidad directa al presente estudio.

**REST vs GraphQL en móvil (2023):** Compara dos arquitecturas de API en aplicaciones móviles, encontrando que GraphQL supera a REST en calidad de software medida desde el cliente. Su aporte es demostrar que la arquitectura de la API afecta el rendimiento del cliente, variable que este estudio mantiene constante (REST) para aislar el efecto de la plataforma. Al centrarse en arquitecturas y no en plataformas, deja abierto el contraste web vs Android.

**Kotlin vs Flutter vs React Native (2025):** Evalúa el rendimiento de tres enfoques de desarrollo móvil en llamadas frecuentes a API, concluyendo que Kotlin nativo es el más rápido y estable, Flutter destaca en renderizado y React Native sufre por el puente JavaScript. Este antecedente confirma que la tecnología del cliente determina el rendimiento, pero al comparar solo frameworks móviles, no aporta evidencia sobre cómo se comportaría una aplicación web bajo las mismas condiciones.

**Xamarin vs nativo (Universidad de Tartu):** Compara el rendimiento de Xamarin frente al desarrollo nativo en arranque y peticiones REST con operaciones masivas sobre SQLite (10,000 registros). Sus resultados muestran que el desarrollo nativo es aproximadamente 2× más rápido en arranque y peticiones, y usa hasta 20× menos memoria. Este estudio aporta evidencia sobre el impacto de la tecnología en el rendimiento y la memoria, pero al comparar frameworks y no plataformas (web vs Android), y al usar SQLite en lugar de SQL Server, no cubre el vacío que esta investigación aborda.
Eficiencia de desempeño según ISO/IEC 25010
La norma ISO/IEC 25010 define la eficiencia de desempeño como la capacidad de un producto de software para proporcionar un rendimiento apropiado, en relación con la cantidad de recursos utilizados bajo condiciones establecidas.
Esta característica se descompone en tres subcaracterísticas medibles: comportamiento temporal (tiempos de respuesta y procesamiento), utilización de recursos (cantidad y tipos de recursos consumidos) y capacidad (límites máximos de parámetros del sistema) .
Un estudio sistemático reciente sobre eficiencia de desempeño en ISO/IEC 25010, que revisó 38 estudios primarios entre 2014 y 2024, identificó que el comportamiento temporal es la subcaracterística más investigada (48% de los estudios), seguida de la utilización de recursos (36%) y la capacidad (16%) .
Este mismo estudio catalogó 68 métricas específicas para evaluar estas subcaracterísticas, lo que proporciona una base objetiva para medir y comparar el rendimiento del software.

## **Marco teórico**

**Eficiencia de desempeño según ISO/IEC 25010**

La norma ISO/IEC 25010 define la eficiencia de desempeño como la capacidad de un producto de software para proporcionar un rendimiento apropiado, en relación con la cantidad de recursos utilizados bajo condiciones establecidas. Esta característica se descompone en tres subcaracterísticas medibles: comportamiento temporal (tiempos de respuesta y procesamiento), utilización de recursos (cantidad y tipos de recursos consumidos) y capacidad (límites máximos de parámetros del sistema) .
Un estudio sistemático reciente sobre eficiencia de desempeño en ISO/IEC 25010, que revisó 38 estudios primarios entre 2014 y 2024, identificó que el comportamiento temporal es la subcaracterística más investigada (48% de los estudios), seguida de la utilización de recursos (36%) y la capacidad (16%) . Este mismo estudio catalogó 68 métricas específicas para evaluar estas subcaracterísticas, lo que proporciona una base objetiva para medir y comparar el rendimiento del software.

ISO/IEC 25010 resulta el estándar adecuado para esta investigación porque proporciona un vocabulario preciso y operacionalizable para definir las métricas de comparación. En lugar de hablar genéricamente de “rapidez” o “ligereza”, la norma permite especificar que se medirá el comportamiento temporal (tiempo de respuesta en milisegundos) y la utilización de recursos (consumo de memoria en megabytes) bajo condiciones controladas y reproducibles.
Esta delimitación conceptual es requisito indispensable para que los resultados de la comparación entre aplicación web y aplicación Android sean interpretables y comparables con la literatura existente.


**Instrumentos de medición**
Para aplicación web:
Chrome DevTools (Performance panel): permite
 registrar y analizar métricas como LCP (Largest Contentful Paint), CLS
 (Cumulative Layout Shift) e INP (Interaction to Next Paint), además de
 proporcionar una línea de tiempo detallada de actividad de red,
 renderizado y ejecución de JavaScript. La API performance.memory permite
 obtener estimaciones del heap JavaScript utilizado.
Para aplicación Android:
Android Profiler (Memory Profiler):
 componente de Android Studio que muestra el uso de memoria en tiempo real,
 permite capturar heap dumps, forzar recolección de basura y rastrear
 asignaciones. Las categorías de memoria reportadas incluyen Java/Kotlin,
 Native, Graphics, Stack, Code y Other.
Para backend y análisis complementario:
JMH (Java Microbenchmark Harness): estándar
 de facto para microbenchmarks en JVM. Permite controlar iteraciones de
 calentamiento, mediciones y evitar sesgos del compilador JIT.
Apache JMeter: herramienta para pruebas de
 carga que simula usuarios concurrentes y mide throughput, tiempo de
 respuesta y tasas de error sobre endpoints HTTP.
La selección de estos instrumentos está fundamentada en su
capacidad para producir mediciones comparables con las reportadas en la
literatura y en su adecuación a las subcaracterísticas de ISO/IEC 25010 que
esta investigación operacionaliza.
Sistemas de inventario y operaciones CRUD
Un sistema de inventario es un tipo de sistema de
información diseñado para gestionar el flujo de productos, existencias y
movimientos dentro de una organización. Las operaciones fundamentales sobre los
recursos de inventario (productos, categorías, movimientos de stock)
corresponden al paradigma CRUD (Create, Read, Update, Delete), que en el
contexto de APIs REST se mapea directamente a los métodos HTTP POST, GET,
PUT/PATCH y DELETE .
El sistema de inventario es un caso representativo para esta
investigación por tres razones:
Operaciones repetitivas: Las consultas de productos y
actualizaciones de existencias son operaciones de alta frecuencia en entornos
empresariales, que las hace susceptibles a diferencias de rendimiento que se
acumulan con el uso.
Volúmenes crecientes de datos: Un catálogo de
inventario puede variar desde cientos hasta cientos de miles de registros. Esta
variabilidad permite estudiar cómo el rendimiento de cada plataforma cliente se
degrada (o no) a medida que aumenta el volumen de información transferida.
Payloads de tamaño variable: Las respuestas de un
endpoint de listado de productos escalan linealmente con el número de registros
solicitados, lo que expone de manera directa las diferencias en los costos de
serialización, transferencia y renderizado entre plataformas.
Esta categoría justifica el dominio de aplicación elegido,
ya que el inventario proporciona un escenario realista donde las decisiones
sobre plataforma cliente (web vs Android) tienen implicaciones prácticas para
desarrolladores y organizaciones que implementan sistemas multiplataforma.
## Operacionalización de variables

| Variable | Definición operacional | Unidad | Instrumento |
| :--- | :--- | :---: | :--- |
| **Tiempo de respuesta web** | ms entre envío de petición fetch y recepción del último byte en Chrome | ms | Chrome DevTools / Performance API (`performance.now()`) |
| **Tiempo de respuesta Android** | ms entre envío con Retrofit y callback `onResponse` | ms | Android Profiler + logs con `System.nanoTime()` |
| **Consumo de memoria web** | MB retenidos en heap JS durante la operación | MB | `performance.memory` (Chrome) |
| **Consumo de memoria Android** | MB retenidos en heap Java/Kotlin durante la operación | MB | Android Profiler (Memory Profiler) |
| **Volumen de registros** | Número de filas en tabla productos/existencias | entero | Script SQL de seeding |
| **Tipo de operación** | CRUD: Create, Read, Update, Delete | categórico | Endpoint invocado |
