
# Cronograma General del Proyecto

## Responsables
- **Web:** VENTURA SIBRIAN RENÉ DANIEL Y RIVERA LÓPEZ MIGUEL ANGEL
- **Móvil:** CHICAS MARTÍNEZ DIEGO ALBERTO Y GRANDE LORENZANA JOSÉ DAVID
- **APIs:** GUILLEN CAMPOS ALEJANDRA CAROLINA y RAMÍREZ RAMÍREZ NELSON EDUARDO

```mermaid
gantt
    title Cronograma General del Proyecto
    dateFormat YYYY-MM-DD
    axisFormat %d/%m

    section Investigación y Planificación
    Selección del tema y organización inicial :done, a1, 2026-09-07, 1d
    Planteamiento del problema :done, a2, 2026-09-08, 1d
    Revisión del planteamiento :done, a3, 2026-09-09, 1d
    Pregunta de investigación :done, a4, 2026-09-10, 1d
    Delimitación del estudio :done, a5, 2026-09-11, 1d
    Objetivos general y específicos :done, a6, 2026-09-12, 1d
    Revisión de objetivos :done, a7, 2026-09-13, 1d
    Justificación :done, a8, 2026-09-14, 1d
    Investigación bibliográfica :done, a9, 2026-09-15, 1d
    Cronograma y viabilidad técnica :done, a10, 2026-09-16, 1d
    Revisión integral del documento :done, a11, 2026-09-17, 1d
    * Entregable 1 - Documento de investigación :milestone, m1, 2026-09-18, 0d

    section Análisis y Diseño
    Levantamiento de requerimientos :b1, 2026-09-19, 7d
    Diseño de arquitectura del sistema :b2, 2026-09-26, 7d
    Diseño de base de datos :b3, 2026-10-03, 5d
    Diseño UI/UX Web y Móvil :b4, 2026-10-08, 10d

    section Desarrollo Web - Alejandra
    Configuración del proyecto web :c1, 2026-10-18, 5d
    Desarrollo de autenticación y seguridad :c2, 2026-10-23, 8d
    Desarrollo de módulos principales :c3, 2026-10-31, 15d
    Integración con APIs :c4, 2026-11-15, 10d
    Ajustes finales y pruebas web :c5, 2026-11-25, 8d

    section Desarrollo Móvil - Diego
    Configuración del proyecto móvil :d1, 2026-10-18, 5d
    Implementación de interfaces móviles :d2, 2026-10-23, 10d
    Desarrollo de funcionalidades principales :d3, 2026-11-02, 13d
    Consumo e integración de APIs :d4, 2026-11-15, 10d
    Pruebas y optimización móvil :d5, 2026-11-25, 8d

    section APIs - Trabajo Compartido
    Diseño de endpoints y contratos :e1, 2026-10-18, 5d
    Implementación de APIs REST :e2, 2026-10-23, 15d
    Validaciones y seguridad :e3, 2026-11-07, 8d
    Integración con base de datos :e4, 2026-11-15, 10d
    Pruebas de rendimiento y documentación :e5, 2026-11-25, 8d

    section Entregables
    * Entregable 2 - Diseño y arquitectura aprobada :milestone, em2, 2026-10-18, 0d
    * Entregable 3 - Primer prototipo funcional :milestone, em3, 2026-11-18, 0d

    section Cierre del Proyecto
    Pruebas integrales del sistema :f1, 2026-12-03, 2d
    Correcciones finales y documentación :f2, 2026-12-05, 1d
    Entrega Final :milestone, mf, 2026-12-06, 0d
```