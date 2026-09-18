## Objetivos

### General

Comparar el rendimiento (tiempo de respuesta y consumo de memoria) entre un cliente web y un cliente Android al consumir los mismos endpoints de una API REST conectada a un sistema de inventario con SQL Server, con el fin de determinar qué plataforma ofrece mejor eficiencia bajo condiciones equivalentes de uso, con cargas de 1,000 , 10,000 y 100,000 registros.

### Específicos

1. **Diseñar e implementar una API REST** para la gestión de inventario (operaciones CRUD sobre productos, categorías y movimientos de stock) conectada a una base de datos SQL Server.
2. **Desarrollar un cliente web y un cliente Android** funcionalmente equivalentes, que consuman los mismos endpoints de la API bajo idénticas condiciones de red y configuración.
3. **Diseñar e implementar un mecanismo de instrumentación** para capturar, de forma automatizada, el tiempo de respuesta (latencia por petición) y el consumo de memoria (RAM) en cada cliente durante el consumo de la API.
4. **Ejecutar pruebas controladas** de 10 repeticiones por cada combinación de cliente y endpoint, calculando el promedio, la desviación estándar y el coeficiente de variación de los resultados obtenidos.
5. **Analizar estadísticamente los resultados** para identificar los umbrales (volumen de datos, tipo de operación o tamaño de payload) en los que la diferencia de rendimiento entre ambos clientes se vuelve significativa.
6. **Formular recomendaciones de diseño** orientadas a arquitecturas de doble canal (web y móvil), basadas en los hallazgos, que orienten decisiones sobre distribución de carga, optimización de consultas o elección de plataforma según el contexto de uso.
