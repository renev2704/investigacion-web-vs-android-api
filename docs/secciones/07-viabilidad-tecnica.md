## Viabilidad Técnica de Investigacion

La presente investigación se considera técnicamente viable debido a que todas las tecnologías, herramientas y recursos requeridos para su desarrollo son de acceso libre, gratuito o ya se encuentran disponibles dentro del entorno de trabajo. Esto permite realizar la implementación y evaluación sin incurrir en costos adicionales de licenciamiento o adquisición de infraestructura.

Para el desarrollo de la solución se utilizarán las siguientes tecnologías:

- **Base de datos:** SQL Server 2022 (edición Developer o Express), disponible gratuitamente para entornos de desarrollo y pruebas.
- **Backend y APIs:** Java 21 con Spring Boot 3.3, empleando OpenJDK y librerías con licencia Apache 2.0.
- **Cliente web:** HTML5, CSS3 y JavaScript, ejecutados y evaluados mediante Google Chrome versión 128.
- **Cliente móvil:** Kotlin 2.0 con Retrofit 2.11 sobre dispositivos con Android 14.

La obtención y análisis de métricas de rendimiento se realizará mediante herramientas especializadas y de libre acceso, entre ellas:

- Scripts personalizados para la automatización de pruebas.
- Android Profiler para la medición de consumo de recursos en la aplicación móvil.
- Android Debug Bridge (ADB) para la captura y monitoreo de métricas del dispositivo.
- Python, junto con las bibliotecas **pandas** y **scipy**, para el procesamiento de datos y el análisis estadístico de los resultados obtenidos.

### Recursos de Hardware

El proyecto cuenta con la infraestructura necesaria para su ejecución:

- **Servidor local:** Intel Core i5-11400, 16 GB de memoria RAM y sistema operativo Windows 11.
- **Dispositivo móvil:** Smartphone con Android 14 y 8 GB de memoria RAM.

Ambos equipos se encuentran disponibles para el equipo de investigación, por lo que no se requiere inversión adicional en hardware.

### Datos de Prueba

Con el fin de garantizar la seguridad de la información, la repetibilidad de los experimentos y la validez de los resultados, se emplearán datos sintéticos generados dentro del propio sistema de inventario. Los escenarios de prueba contemplarán conjuntos de datos con volúmenes de:

- 1,000 registros
- 10,000 registros
- 100,000 registros

Esta estrategia elimina la necesidad de utilizar información sensible o confidencial y permite reproducir las pruebas bajo condiciones controladas.

### Análisis de Riesgos y Medidas de Mitigación

Aunque se identifican algunos riesgos técnicos potenciales, todos cuentan con estrategias de mitigación viables que reducen significativamente su impacto en la investigación.

#### 1. Variaciones en las condiciones de red
Las diferencias en la calidad de la conexión podrían afectar los tiempos de respuesta observados entre las aplicaciones web y móvil.

**Medida de mitigación:**  
Realizar las pruebas dentro de una misma red local (LAN) utilizando un servidor local dedicado, garantizando condiciones homogéneas para ambos clientes.

#### 2. Diferencias en la medición de memoria entre plataformas
Los mecanismos de monitoreo disponibles para aplicaciones web y móviles no son exactamente equivalentes.

**Medida de mitigación:**  
Reportar las métricas de memoria de forma independiente para cada plataforma, utilizando `performance.memory` en el cliente web y **Android Profiler** en el cliente móvil, manteniendo criterios de análisis consistentes.

#### 3. Variabilidad producida por procesos en segundo plano
La ejecución de servicios externos o aplicaciones residentes puede introducir fluctuaciones en los resultados.

**Medida de mitigación:**  
Realizar diez repeticiones por cada escenario de prueba, reiniciar los servicios antes de cada medición y calcular medidas estadísticas de dispersión, como la desviación estándar, para identificar posibles anomalías.

### Conclusión

Considerando la disponibilidad de herramientas, recursos de hardware, tecnologías de desarrollo y mecanismos de mitigación de riesgos, se concluye que el proyecto posee las condiciones necesarias para su ejecución. Los riesgos identificados presentan una probabilidad e impacto bajos y cuentan con planes alternativos claramente definidos, por lo que la **viabilidad técnica de la investigación se considera aprobada**.