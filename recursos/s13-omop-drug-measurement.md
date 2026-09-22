# Material complementario — Sesión 13

## OMOP CDM: Drug Exposure, Measurement y Tablas Derivadas

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Modelar exposición a medicamentos y resultados de laboratorio en OMOP
- Distinguir MEASUREMENT de OBSERVATION y saber dónde buscar cada dato
- Construir y usar tablas derivadas: DRUG_ERA, CONDITION_ERA, DOSE_ERA
- Manejar unidades, valores fuera de rango y la variabilidad de los datos de laboratorio

## Especificación de las tablas

- ★ [**OMOP CDM v5.4 — DRUG_EXPOSURE**](https://ohdsi.github.io/CommonDataModel/cdm54.html#drug_exposure)
  ★ Campo por campo, con las convenciones de ETL. Presta atención a `drug_type_concept_id`.
- [**OMOP CDM v5.4 — MEASUREMENT**](https://ohdsi.github.io/CommonDataModel/cdm54.html#measurement)
  Incluye la guía oficial de cuándo usar MEASUREMENT y cuándo OBSERVATION.
- [**OMOP CDM v5.4 — OBSERVATION**](https://ohdsi.github.io/CommonDataModel/cdm54.html#observation)
  La otra mitad de la decisión. Léelas juntas.
- [**OMOP CDM v5.4 — DRUG_ERA**](https://ohdsi.github.io/CommonDataModel/cdm54.html#drug_era)
  Definición y algoritmo de construcción, con el gap de 30 días como convención.
- [**OMOP CDM v5.4 — CONDITION_ERA y DOSE_ERA**](https://ohdsi.github.io/CommonDataModel/cdm54.html#condition_era)
  Las otras dos tablas derivadas.
- [**OMOP CDM v5.4 — PAYER_PLAN_PERIOD**](https://ohdsi.github.io/CommonDataModel/cdm54.html#payer_plan_period)
  En bases de claims, la cobertura define cuándo ves al paciente. Primo de OBSERVATION_PERIOD.
- [**THEMIS — convenciones acordadas**](https://ohdsi.github.io/Themis/)
  Para los casos grises de «¿esto en qué tabla va?». Es la fuente de verdad de la comunidad.

## Cómo construir las tablas derivadas

- ★ [**The Book of OHDSI — Cap. 5: Standardized Vocabularies**](https://ohdsi.github.io/TheBookOfOhdsi/StandardizedVocabularies.html)
  Necesario para entender por qué las eras se construyen al nivel de ingrediente.
- [**The Book of OHDSI — Cap. 6: ETL**](https://ohdsi.github.io/TheBookOfOhdsi/ExtractTransformLoad.html)
  Incluye cómo se generan las tablas derivadas después de la conversión.
- [**CommonDataModel — scripts de tablas derivadas**](https://github.com/OHDSI/CommonDataModel)
  El SQL oficial que construye DRUG_ERA y CONDITION_ERA. Compáralo con el tuyo.
- [**The SQL of Gaps and Islands**](https://www.red-gate.com/simple-talk/databases/sql-server/t-sql-programming-sql-server/the-sql-of-gaps-and-islands-in-sequences/)
  El patrón que construye las eras, explicado a fondo (sesión 11).

## Unidades y plausibilidad

- ★ [**UCUM — Unified Code for Units of Measure**](https://ucum.org/)
  El estándar de unidades que usa OMOP. Explica por qué `mg/dL` se escribe así y no de otra forma.
- [**Unit conversion (LOINC)**](https://loinc.org/kb/faq/structure/)
  Cómo LOINC trata las unidades y por qué el mismo analito puede tener varios códigos.
- [**Data quality of EHR: plausibility checks (Kahn et al., eGEMs)**](https://doi.org/10.13063/2327-9214.1244)
  ★ El marco conceptual de calidad de datos: conformance, completeness, plausibility. Vocabulario estándar del campo.
- [**MDCalc**](https://www.mdcalc.com/)
  Catálogo de scores y rangos clínicos validados, con sus referencias. Útil para citar rangos plausibles en vez de inventarlos.
- [**Achilles Heel — verificaciones de plausibilidad**](https://github.com/OHDSI/Achilles)
  Las reglas que la comunidad usa para detectar valores imposibles.

## Calidad de datos

- ★ [**Data Quality Dashboard**](https://ohdsi.github.io/DataQualityDashboard/)
  ★ Más de 3 000 verificaciones automáticas sobre una base OMOP, organizadas por el marco de Kahn.
- [**DQD — catálogo de verificaciones**](https://ohdsi.github.io/DataQualityDashboard/articles/CheckTypeDescriptions.html)
  Qué revisa cada una. Útil aunque no ejecutes la herramienta.
- [**Achilles**](https://github.com/OHDSI/Achilles)
  Caracterización descriptiva automática: qué hay realmente en la base.
- [**dbt-synthea — calidad como tests**](https://github.com/OHDSI/dbt-synthea/blob/main/DATA_QUALITY.md)
  Las verificaciones del DQD implementadas como tests de dbt. El puente entre la sesión 5 y ésta.

## Farmacoepidemiología

- ★ [**ISPE — Guidelines for Good Pharmacoepidemiology Practices**](https://pharmacoepi.org/resources/policies/guidelines-08027/)
  Estándares metodológicos del campo.
- [**Navigating the Wild West of Medication Adherence Reporting (JMCP, 2019)**](https://www.jmcp.org/doi/10.18553/jmcp.2019.25.10.1073)
  ★ PDC contra MPR: por qué las metodologías varían, por qué MPR puede pasar de 100% con surtidos anticipados y por qué PDC es hoy el estándar.
- [**Understanding medication adherence metrics: PDC y MPR**](https://acarepro.abbott.com/articles/general-topics/medication-adherence-metrics-2/)
  Explicación corta y clara de ambas, con el umbral convencional de 0.8.
- [**Prevalence and predictors of primary nonadherence (CMAJ, 2023)**](https://pubmed.ncbi.nlm.nih.gov/37553145/)
  Cohorte de 150 565 prescripciones nuevas: el 17% nunca se surtió. Es el dato real detrás de la figura del embudo.
- [**New-user designs (Ray, Am J Epidemiol 2003)**](https://doi.org/10.1093/aje/kwg231)
  Por qué importa distinguir usuarios nuevos de prevalentes. Se usa a fondo en la sesión 17.

