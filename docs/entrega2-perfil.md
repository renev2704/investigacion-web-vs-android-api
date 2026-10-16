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

## **Arquitecturas de consumo de APIs REST**
REST (Representational State Transfer) es un estilo arquitectónico para sistemas distribuidos, no una tecnología ni un toolkit específico. Su implementación se rige por una serie de restricciones de diseño que, cuando se cumplen en su totalidad, permiten calificar un servicio como “RESTful” . Las restricciones más relevantes para el consumo desde aplicaciones cliente son:

**Cliente-servidor:** Separa las preocupaciones de interfaz de usuario (cliente) de las de almacenamiento y procesamiento de datos (servidor), permitiendo que cada componente evolucione independientemente.

**Sin estado (stateless):** El servidor no mantiene información de sesión entre llamadas. Cada petición debe contener toda la información necesaria para ser procesada, lo que simplifica la escalabilidad del servidor, pero traslada al cliente la responsabilidad de gestionar el estado .

**Interfaz uniforme:** Los recursos se identifican mediante URIs y se manipulan con un conjunto fijo de métodos HTTP (GET, POST, PUT, DELETE). Esta uniformidad simplifica el desacoplamiento arquitectónico.

**Cacheable:** Las respuestas deben indicar explícitamente si son cacheables o no, lo que permite reducir interacciones y mejorar el rendimiento percibido.
La diferencia fundamental entre consumir una API REST desde una **aplicación web** (HTML/CSS/JavaScript en navegador) y desde una **aplicación Android** (Kotlin/Retrofit) reside en el **modelo de ejecución y gestión de recursos** de cada plataforma:
**En la aplicación web**, el navegador gestiona el ciclo de vida de las peticiones mediante fetch o XMLHttpRequest, aplica políticas de seguridad como CORS (Cross-Origin Resource Sharing), y delega la gestión de memoria al motor JavaScript del navegador. El costo de serialización/deserialización JSON ocurre en el hilo principal o en Web Workers, y la memoria está sujeta a las políticas de recolección de basura del navegador.
En la aplicación Android, el framework proporciona bibliotecas especializadas como Retrofit/OkHttp que operan sobre el modelo de concurrencia de Android (hilos, corrutinas). La serialización JSON se realiza en el hilo de fondo, y la memoria utilizada proviene del heap gestionado por ART (Android Runtime), sujeto a las restricciones específicas de memoria por aplicación que impone el sistema operativo.
Un estudio empírico que comparó aplicaciones nativas y aplicaciones web consumiendo los mismos servicios RESTful encontró que **las aplicaciones web no siempre presentan peor rendimiento que las nativas.** Los patrones de uso difieren según el estilo arquitectónico de cada plataforma, y variables como el número de conexiones de red, el tiempo de respuesta y el consumo de datos muestran diferencias que dependen del contexto.

## **Métricas de rendimiento en aplicaciones**

Las métricas de rendimiento cuantifican aspectos observables del comportamiento del software. Para esta investigación, las métricas centrales derivadas de ISO/IEC 25010 son:

**Tiempo de respuesta:** Intervalo transcurrido entre el envío de una petición y la recepción completa de la respuesta. Esta métrica corresponde a la subcaracterística de comportamiento temporal. En aplicaciones web puede capturarse mediante performance.now() en JavaScript o la API de Performance del navegador. En Android, se registra mediante instrumentación con System.nanoTime() antes y después de la llamada al servicio.

**Consumo de memoria:** Cantidad de memoria retenida durante la ejecución de una operación. Esta métrica corresponde a la subcaracterística de utilización de recursos. La medición debe realizarse con instrumentos específicos de cada plataforma, ya que los modelos de memoria son fundamentalmente distintos.
