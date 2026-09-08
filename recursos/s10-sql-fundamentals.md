# Material complementario — Sesión 10

## SQL Fundamentals: Queries, Joins y Agregaciones

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Escribir consultas SELECT con filtrado, ordenamiento y agregación sobre datos clínicos
- Combinar tablas con los cuatro tipos de JOIN y predecir la cardinalidad del resultado
- Comprender el orden lógico de ejecución de una consulta
- Leer un plan de ejecución y entender por qué una consulta es lenta

## Práctica interactiva (empieza aquí)

- ★ [**SQLBolt**](https://sqlbolt.com/)
  Lecciones interactivas de cero a joins, en el navegador. Dos horas y ya escribes SQL. La mejor primera parada.
- [**PostgreSQL Exercises**](https://pgexercises.com/)
  80+ ejercicios con solución y explicación, específicos de Postgres.
- [**Select Star SQL**](https://selectstarsql.com/)
  Libro interactivo gratuito sobre un dataset real. Enseña a *pensar* en SQL, no sólo sintaxis.
- [**Mode — SQL Tutorial**](https://mode.com/sql-tutorial/)
  Muy orientado a analistas, con datos reales y buenas explicaciones de joins.
- [**SQL Murder Mystery (Knight Lab)**](https://mystery.knightlab.com/)
  Resuelves un asesinato escribiendo consultas sobre una base SQLite. Sorprendentemente efectivo para practicar joins; hay walkthrough si te atoras.

## Documentación de motores

- ★ [**DuckDB — SQL Introduction**](https://duckdb.org/docs/stable/sql/introduction)
  Motor columnar sin servidor: corre en tu proceso y en Colab. La opción de menor fricción para el laboratorio.
- [**DuckDB — Importar CSV**](https://duckdb.org/docs/stable/data/csv/overview)
  `read_csv_auto` infiere tipos y carga directo. Es la actividad 3 en dos líneas.
- [**PostgreSQL — Tutorial oficial**](https://www.postgresql.org/docs/current/tutorial.html)
  Sobrio pero completo. Lo que usan las herramientas de OHDSI.
- [**PostgreSQL — Referencia de SQL**](https://www.postgresql.org/docs/current/sql.html)
  La referencia definitiva de sintaxis.
- [**PostgreSQL — Funciones de fecha y hora**](https://www.postgresql.org/docs/current/functions-datetime.html)
  Aritmética de fechas: la usarás en cada consulta clínica.

## Joins, NULL y las trampas

- ★ [**Visual JOIN (interactivo)**](https://joins.spathon.com/)
  Ver el resultado de cada join fila por fila mientras cambias el tipo. Aclara la cardinalidad mejor que cualquier diagrama de conjuntos. Disponible en español.
- [**SQL NULL handling — Modern SQL**](https://modern-sql.com/concept/three-valued-logic)
  La lógica de tres valores: por qué `NULL = NULL` no es verdadero y qué se rompe por eso.
- [**A Beginner's Guide to the True Order of SQL Operations**](https://blog.jooq.org/a-beginners-guide-to-the-true-order-of-sql-operations/)
  El orden lógico de ejecución explicado a fondo. La diapositiva más importante de la sesión, ampliada.

## Rendimiento

- ★ [**Use The Index, Luke!**](https://use-the-index-luke.com/es)
  Libro en línea gratuito sobre índices y rendimiento. **Disponible en español.** Empieza por 'Anatomía de un índice'.
- [**PostgreSQL — Using EXPLAIN**](https://www.postgresql.org/docs/current/using-explain.html)
  Cómo leer un plan de ejecución.
- [**explain.dalibo.com**](https://explain.dalibo.com/)
  Pega tu plan y lo visualiza. Encuentra el cuello de botella en segundos.
- [**DuckDB — Performance guide**](https://duckdb.org/docs/stable/guides/performance/overview)
  Por qué en un motor columnar los índices importan menos. Respalda el hallazgo de la actividad 9.

## Estilo y libros

- ★ [**SQL Style Guide (Simon Holywell)**](https://www.sqlstyle.guide/es/)
  Convenciones de formato. En español. Adóptalas desde hoy: el SQL se lee más de lo que se escribe.
- [**SQL for Data Analysis (Cathy Tanimura, O'Reilly)**](https://www.oreilly.com/library/view/sql-for-data/9781492088776/)
  Bibliografía base del curso. Muy orientado a análisis real, no a administración de bases.
- [**Practical SQL, 2ª ed. (Anthony DeBarros)**](https://nostarch.com/practical-sql-2nd-edition)
  Enfoque práctico con datos públicos, incluidos datos de salud.

## Para las entrevistas (sesión 32)

- ★ [**DataLemur — SQL Interview Questions**](https://datalemur.com/questions)
  Preguntas reales de entrevistas de empresas de datos, con solución explicada.
- [**StrataScratch**](https://www.stratascratch.com/)
  Problemas de entrevistas reales, filtrables por empresa y dificultad.
- [**LeetCode — Top SQL 50**](https://leetcode.com/studyplan/top-sql-50/)
  Los 50 problemas de SQL más frecuentes en procesos de selección.

