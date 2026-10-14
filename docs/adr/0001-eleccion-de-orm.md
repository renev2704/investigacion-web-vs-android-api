# ADR 0001 – Elección de la estrategia de acceso a datos

Fecha: 2026-10-13
Estado: aceptada

## Contexto

Necesitamos que el backend Spring Boot 3.3 acceda a SQL Server 2022 de forma
que las mediciones de tiempo de respuesta reflejen el comportamiento real del
sistema, sin sesgos introducidos por la capa de persistencia.

## Opciones consideradas

1. **JPA/Hibernate** – estándar de facto en Spring Boot, mapeo objeto-relacional,
   pero puede introducir sobrecarga en consultas complejas.
2. **JdbcTemplate** – acceso directo a SQL, menor sobrecarga, pero más código
   boilerplate.
3. **MyBatis** – mapeo SQL explícito, equilibrio entre control y productividad.

## Decisión

Se adopta **JPA/Hibernate** con consultas JPQL y proyecciones DTO para las
operaciones de lectura. Justificación: es el estándar en Spring Boot 3.3,
facilita la reproducibilidad y permite declarar claramente las consultas.

## Consecuencias

- Aumenta ligeramente el tiempo de respuesta en comparación con JdbcTemplate,
  pero este efecto se controla al mantener la misma configuración en ambos
  clientes.
- Se documentan las consultas JPQL en el repositorio para facilitar la réplica.
- Si en el futuro se requiere medir el efecto de la capa de persistencia, se
  puede añadir un factor adicional al diseño experimental.