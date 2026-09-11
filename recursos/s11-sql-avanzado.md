# Material complementario — Sesión 11

## SQL Avanzado: CTEs, Window Functions y Subqueries

*Bloque III — SQL y datos clínicos estandarizados*


## Objetivos que apoya este material

- Descomponer consultas complejas en CTEs legibles y encadenadas
- Resolver problemas de secuencia temporal con funciones de ventana
- Elegir entre subquery, CTE, join y window function con criterio
- Escribir SQL analítico mantenible sobre datos longitudinales de pacientes

## Documentación oficial

- ★ [**PostgreSQL — Window Functions (tutorial)**](https://www.postgresql.org/docs/current/tutorial-window.html)
  Introducción oficial, corta y buena. Empieza aquí.
- [**PostgreSQL — Sintaxis de ventana y frames**](https://www.postgresql.org/docs/current/sql-expressions.html#SYNTAX-WINDOW-FUNCTIONS)
  La referencia de `OVER`, `PARTITION BY` y sobre todo `ROWS`/`RANGE`.
- [**PostgreSQL — Funciones de ventana disponibles**](https://www.postgresql.org/docs/current/functions-window.html)
  El catálogo completo: `ROW_NUMBER`, `LAG`, `NTILE` y compañía.
- [**PostgreSQL — WITH Queries (CTEs)**](https://www.postgresql.org/docs/current/queries-with.html)
  Incluye CTEs recursivos y la nota sobre `MATERIALIZED`.
- [**DuckDB — Window Functions**](https://duckdb.org/docs/stable/sql/functions/window_functions)
  Mismo estándar, con extensiones cómodas como `QUALIFY`.
- [**DuckDB — QUALIFY**](https://duckdb.org/docs/stable/sql/query_syntax/qualify)
  Filtra por el resultado de una función de ventana sin envolver en CTE. Ahorra el paso de la actividad 7.

## Entender las ventanas a fondo

- ★ [**Modern SQL — Window Functions (OVER)**](https://modern-sql.com/feature/over)
- [**SQL Window Functions Cheat Sheet (LearnSQL)**](https://learnsql.com/blog/sql-window-functions-cheat-sheet/)
- [**Window Functions — Use The Index, Luke!**](https://use-the-index-luke.com/sql/partial-results/window-functions)

## Gaps and islands y patrones temporales

- ★ [**The SQL of Gaps and Islands in Sequences (Red Gate)**](https://www.red-gate.com/simple-talk/databases/sql-server/t-sql-programming-sql-server/the-sql-of-gaps-and-islands-in-sequences/)
  El patrón explicado a fondo, con variantes. Es el algoritmo de los episodios de tratamiento.
- [**OMOP CDM — DRUG_ERA**](https://ohdsi.github.io/CommonDataModel/cdm54.html#drug_era)
  La tabla derivada que implementa exactamente ese patrón con un gap de 30 días. Lo verás en la sesión 13.
- [**Medication adherence: PDC y MPR**](https://pubmed.ncbi.nlm.nih.gov/23218021/)
  Para qué sirven los episodios: medir adherencia. Cómo se calculan y por qué difieren.

## Práctica

- ★ [**Advanced SQL Puzzles**](https://github.com/smpetersgithub/AdvancedSQLPuzzles)
  Colección de problemas difíciles con solución. Varios son de ventanas.
- [**PostgreSQL Exercises — Aggregates**](https://pgexercises.com/questions/aggregates/)
  La sección de agregación incluye ejercicios de ventana con solución explicada.
- [**DataLemur — Window Functions**](https://datalemur.com/questions?category=Window%20Function)
  Preguntas de entrevista específicas de funciones de ventana.

## Organizar SQL analítico

- ★ [**PostgreSQL — Vistas materializadas**](https://www.postgresql.org/docs/current/rules-materializedviews.html)
  Cuándo guardar el resultado en vez de recalcularlo, y cómo refrescarlo.
- [**SQL Style Guide (Simon Holywell)**](https://www.sqlstyle.guide/es/)
  Convenciones de formato, en español. Con CTEs largas importa más que nunca.
- [**SQLFluff**](https://docs.sqlfluff.com/)
  El «ruff» del SQL: linter y formateador. Se integra con pre-commit igual que en la sesión 5.

## dbt: llevar al SQL lo que ya sabes de ingeniería

- ★ [**dbt — ¿Qué es dbt?**](https://docs.getdbt.com/docs/introduction)
  ★ Empieza aquí. En una página: qué problema resuelve y por qué se volvió estándar.
- [**dbt Fundamentals (curso gratuito)**](https://learn.getdbt.com/)
  Curso oficial, gratis y con certificado. Unas 5 horas. Es la forma más rápida de pasar de «he oído hablar de dbt» a poder usarlo.
- [**dbt — Documentación**](https://docs.getdbt.com/)
  La referencia completa.
- [**dbt — Modelos**](https://docs.getdbt.com/docs/build/models)
  La unidad básica: un archivo `.sql` con un `SELECT`. dbt se encarga del `CREATE TABLE`, del orden y de las dependencias.
- [**dbt — Tests de datos**](https://docs.getdbt.com/docs/build/data-tests)
  Pruebas declarativas sobre los datos: unicidad, no nulos, valores permitidos, integridad referencial. Es pytest, pero para tablas.
- [**dbt — Documentación y linaje**](https://docs.getdbt.com/docs/build/documentation)
  Genera un sitio navegable con el grafo de dependencias entre modelos. Responde «¿qué se rompe si cambio esta tabla?».
- [**dbt — Jinja y macros**](https://docs.getdbt.com/docs/build/jinja-macros)
  SQL con variables, condicionales y funciones reutilizables. Es lo que permite parametrizar una definición de cohorte.
- [**dbt — Cómo estructuramos nuestros proyectos**](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview)
  La convención staging → intermediate → marts. Léela antes de organizar tu primer proyecto.
- [**dbt — Best practices**](https://docs.getdbt.com/best-practices)
  Guías acumuladas de la comunidad.
- [**dbt Core — Instalación**](https://docs.getdbt.com/docs/core/installation-overview)
  dbt Core es la herramienta abierta y gratuita (línea de comandos); dbt Cloud es el servicio comercial. Para el curso y tu tesis, Core basta.
- [**dbt-duckdb (adaptador)**](https://github.com/duckdb/dbt-duckdb)
  Ejecuta dbt sobre DuckDB: cero infraestructura, ideal para probarlo en tu laptop con los datos del curso.
- [**dbt-postgres (adaptador)**](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)
  Si montaste Postgres en el laboratorio 10, es el adaptador que te toca.

## dbt aplicado a OMOP

- ★ [**dbt-synthea (OHDSI)**](https://github.com/OHDSI/dbt-synthea)
  ★ Proyecto oficial de OHDSI que convierte datos de Synthea a OMOP CDM **usando dbt**. Es literalmente lo que harás a mano en la sesión 12, hecho como proyecto de ingeniería analítica. Léelo aunque no lo ejecutes.
- [**dbt-synthea — calidad de datos**](https://github.com/OHDSI/dbt-synthea/blob/main/DATA_QUALITY.md)
  Las verificaciones del Data Quality Dashboard implementadas como tests de dbt. El puente exacto entre la sesión 5 (pruebas) y la 13 (calidad de datos clínicos).
- [**Tutorial ETL de OHDSI con dbt-synthea**](https://github.com/OHDSI/Tutorial-ETL/blob/master/etl/dbt-synthea/README.md)
  El tutorial oficial de ETL de la comunidad, en su versión con dbt.
- [**dbt for OMOP, fase I (OHDSI 2024)**](https://www.ohdsi.org/wp-content/uploads/2024/10/124-Sadowski-dbt-synthea-Abstract-Julien-Nakache.pdf)
  El resumen que presentó el proyecto en el simposio. Dos páginas: qué se buscaba y por qué dbt.
- [**Usar dbt para transformar datos a OMOP CDM (Siriraj Hospital, OHDSI 2022)**](https://www.ohdsi.org/wp-content/uploads/2022/10/2-Pitchayarat-abstract.pdf)
  Caso real de un hospital que hizo su ETL a OMOP con dbt.
- [**Implementing the OMOP CDM using dbt (OHDSI 2023)**](https://www.ohdsi.org/wp-content/uploads/2023/10/20-Ashcroft-BriefReport.pdf)
  Otro reporte breve de la comunidad, con las lecciones aprendidas.

