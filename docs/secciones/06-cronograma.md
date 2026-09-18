
# Cronograma General del Proyecto

## Responsables
- **Web:** VENTURA SIBRIAN RENÉ DANIEL Y RIVERA LÓPEZ MIGUEL ANGEL
- **Móvil:** CHICAS MARTÍNEZ DIEGO ALBERTO Y GRANDE LORENZANA JOSÉ DAVID
- **APIs:** GUILLEN CAMPOS ALEJANDRA CAROLINA Y RAMÍREZ RAMÍREZ NELSON EDUARDO

```mermaid
gantt
    title Cronograma General del Proyecto
    dateFormat YYYY-MM-DD
    axisFormat %d/%m

    section Entrega 1: Perfil
Definición del tema           :done, t1, 2026-08-24, 7d
Redacción del perfil          :done, t2, after t1, 10d
Revisión y entrega de perfil  :milestone, m1, 2026-09-18, 0d

section Entrega 2: Marco y metodología
Estado del arte               :active, t3, 2026-09-19, 12d
Diseño experimental           :t4, after t3, 6d
Definición de métricas        :t5, after t4, 4d
Revisión y entrega parcial    :milestone, m2, 2026-10-10, 0d

section Entrega 3: Desarrollo e instrumentación
Diseño de API REST            :t6, 2026-10-11, 5d
Implementación backend        :t7, after t6, 8d
Cliente web                   :t8, after t7, 6d
Cliente Android               :t9, after t7, 6d
Instrumentación de métricas   :t10, after t8, 4d
Pruebas piloto                :t11, after t10, 4d
Revisión y entrega parcial    :milestone, m3, 2026-11-13, 0d

section Entrega 4: Experimentos y resultados
Generación de datos (1k/10k/100k) :t12, 2026-11-14, 4d
Experimentos formales (10 repeticiones) :crit, t13, after t12, 8d
Holgura para repetición de experimentos :t14, after t13, 5d
Análisis estadístico          :t15, after t14, 4d
Redacción de resultados       :t16, after t15, 3d
Conclusiones y recomendaciones:t17, after t16, 2d
Entrega final y defensa       :milestone, m4, 2026-12-06, 0d
```