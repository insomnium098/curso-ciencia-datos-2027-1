# Material complementario — Sesión 16

## Navegación Jerárquica: concept_relationship y concept_ancestor

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Diferenciar CONCEPT_RELATIONSHIP (relaciones directas) de CONCEPT_ANCESTOR (cierre transitivo)
- Recorrer jerarquías con SQL recursivo y con la tabla de ancestros
- Construir concept sets por descendencia de forma eficiente y auditable
- Diagnosticar por qué un concept set incluye o excluye lo que no esperabas

## Empieza por aquí

- ★ [**The Book of OHDSI — Cap. 5: Standardized Vocabularies**](https://ohdsi.github.io/TheBookOfOhdsi/StandardizedVocabularies.html)
  La sección de estructura del vocabulario explica las jerarquías con diagramas. Es la base de toda la sesión.
- [**ATHENA — vista de jerarquía**](https://athena.ohdsi.org/)
  En cada concepto, las pestañas de relaciones y jerarquía te muestran visualmente lo mismo que estás consultando en SQL. Tenlas abiertas mientras escribes las consultas.
- [**SNOMED CT Browser**](https://browser.ihtsdotools.org/)
  La mejor forma de ver poli-jerarquía en acción: busca un concepto y mira cuántos padres tiene.

## La especificación

- ★ [**OMOP CDM v5.4 — CONCEPT_ANCESTOR**](https://ohdsi.github.io/CommonDataModel/cdm54.html#concept_ancestor)
  Definición formal de las cuatro columnas y de qué relaciones entran en el cierre transitivo.
- [**OMOP CDM v5.4 — CONCEPT_RELATIONSHIP**](https://ohdsi.github.io/CommonDataModel/cdm54.html#concept_relationship)
  Las aristas directas, con sus fechas de validez e `invalid_reason`.
- [**OMOP CDM v5.4 — RELATIONSHIP**](https://ohdsi.github.io/CommonDataModel/cdm54.html#relationship)
  El catálogo de tipos de relación. Aquí viven `is_hierarchical` y `defines_ancestry`, las banderas que deciden qué entra en CONCEPT_ANCESTOR.
- [**Convenciones del modelo de datos**](https://ohdsi.github.io/CommonDataModel/dataModelConventions.html)
  Las reglas que no están en la definición de cada tabla, incluidas las de vocabulario.

## SQL recursivo

- ★ [**Modern SQL — WITH RECURSIVE**](https://modern-sql.com/feature/with/recursive)
  La mejor explicación conceptual que existe: qué hace el motor en cada iteración, y por qué el freno es obligatorio.
- [**PostgreSQL — Recursive Queries**](https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-RECURSIVE)
  Documentación oficial, con ejemplos de recorrido de grafos y de deteccion de ciclos.
- [**DuckDB — WITH / recursive CTE**](https://duckdb.org/docs/stable/sql/query_syntax/with)
  La sintaxis en el motor que usas en los laboratorios. Casi idéntica a la de Postgres.

## Auditar concept sets

- ★ [**CohortDiagnostics**](https://ohdsi.github.io/CohortDiagnostics/)
  Audita concept sets automáticamente: códigos fuente realmente usados, desglose del evento índice y conceptos huérfanos.
- [**What is Cohort Diagnostics?**](https://ohdsi.github.io/CohortDiagnostics/articles/WhatIsCohortDiagnostics.html)
  La introducción corta. Léela antes de instalar nada.
- [**Viewing results using Diagnostics Explorer**](https://ohdsi.github.io/CohortDiagnostics/articles/ViewingResultsUsingDiagnosticsExplorer.html)
  Qué significa cada pantalla. Los **conceptos huérfanos** son los códigos que deberías haber incluido y no incluiste: el diagnóstico más útil de todos.
- [**OHDSI Phenotype Library**](https://github.com/OHDSI/PhenotypeLibrary)
  Concept sets revisados por pares. Úsalos como referencia de cómo se ve uno bien construido.

## Rendimiento

- ★ [**Use the Index, Luke!**](https://use-the-index-luke.com/)
  Curso gratuito sobre índices y planes de ejecución. Los capítulos de `JOIN` y de subconsultas son directamente aplicables a lo del laboratorio.
- [**PostgreSQL — Using EXPLAIN**](https://www.postgresql.org/docs/current/using-explain.html)
  Cómo leer un plan de ejecución sin adivinar.

## Cómo usar este material

1. **Antes de la clase:** revisa los recursos marcados con ★ (30–45 min).
2. **Durante el laboratorio:** ten abiertas las páginas de documentación oficial.
3. **Después:** elige un recurso de profundización relacionado con tu proyecto final.

## Enlaces del curso

- Diapositivas: [`slides/s16-jerarquias-concept-ancestor.md`](../slides/s16-jerarquias-concept-ancestor.md)
- Laboratorio: [`labs/s16-jerarquias-concept-ancestor/`](../labs/s16-jerarquias-concept-ancestor/)
- Temario completo: [`README.md`](../README.md)

---

¿Encontraste un recurso mejor? Abre un *issue* o un *pull request*: este material se mejora con las aportaciones del grupo.

