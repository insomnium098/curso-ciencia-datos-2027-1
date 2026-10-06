# Material complementario — Sesión 17

## Diseño de Cohortes Clínicas en OMOP con SQL

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Traducir una pregunta clínica en una definición de cohorte operacionalizable
- Implementar en SQL los cuatro componentes de una cohorte: entrada, inclusión, salida, salida de estudio
- Manejar correctamente ventanas temporales, periodo de lavado y observabilidad
- Producir una tabla de cohorte reutilizable en el esquema `results`

## Empieza por aquí

- ★ [**The Book of OHDSI — Cap. 10: Defining Cohorts**](https://ohdsi.github.io/TheBookOfOhdsi/Cohorts.html)
  El capítulo central de esta sesión. Léelo completo **antes** de la clase: la sesión da por supuesto su vocabulario.
- [**The Book of OHDSI — Cap. 12: Population-Level Estimation**](https://ohdsi.github.io/TheBookOfOhdsi/PopulationLevelEstimation.html)
  Para qué sirve, al final, la cohorte que estás construyendo.

## Los dos artículos que hay que leer

- ★ [**Ray WA. Evaluating medication effects outside of clinical trials: new-user designs. *Am J Epidemiol.* 2003;158(9):915-920.**](https://doi.org/10.1093/aje/kwg231)
  El artículo que estableció el diseño de nuevo usuario. Corto, y explica por qué los usuarios prevalentes son sobrevivientes.
- [**Suissa S. Immortal time bias in pharmacoepidemiology. *Am J Epidemiol.* 2008;167(4):492-499.**](https://pubmed.ncbi.nlm.nih.gov/18056625/)
  El sesgo más invisible de todos: la consulta corre bien, el resultado es espectacular, y está mal. Con el caso de cáncer de pulmón.

## Herramientas OHDSI

- ★ [**ATLAS — demo pública**](https://atlas-demo.ohdsi.org/)
  Construye la misma cohorte con interfaz gráfica y mira el SQL que genera. Es largo y feo a propósito: cubre casos borde que tú no cubriste.
- [**ATLAS — Cohort definitions (wiki)**](https://github.com/OHDSI/Atlas/wiki/Cohort-Definitions)
  La semántica exacta de cada criterio de la interfaz. Útil como diccionario cuando traduzcas de ATLAS a SQL.
- [**CIRCE / CirceR**](https://github.com/OHDSI/CirceR)
  El motor que convierte una definición JSON en SQL. Leer su salida enseña mucho sobre lo que se te olvidó.
- [**CohortGenerator**](https://ohdsi.github.io/CohortGenerator/)
  Paquete de R para generar cohortes de forma reproducible, pensado para estudios en red.
- [**OHDSI Phenotype Library**](https://github.com/OHDSI/PhenotypeLibrary)
  Cohortes ya definidas y revisadas por pares. Reutiliza antes de reinventar.

## Cómo se reporta

- ★ [**HARPER — plantilla de protocolo (acceso libre)**](https://drugepi.gitlab-pages.partners.org/harper/)
  La plantilla completa, navegable y descargable, sin necesidad de suscripción. Es lo que te van a pedir si publicas.
- [**HARPER — reporte de la fuerza de tarea ISPE/ISPOR**](https://www.ispor.org/heor-resources/good-practices/article/harmonized-protocol-template-to-enhance-reproducibility-of-hypothesis-evaluating-real-world-evidence-studies-on-treatment-effects)
  El documento original: Wang SV, Pottegård A, Crown WH, et al. *Value Health.* 2022;25(10):1663-1672.
- [**RECORD Statement**](https://www.record-statement.org/)
  Extensión de STROBE para estudios con datos recolectados de rutina. El más aplicable a lo que haces aquí.
- [**STROBE Statement**](https://www.strobe-statement.org/)
  La checklist base para estudios observacionales.



