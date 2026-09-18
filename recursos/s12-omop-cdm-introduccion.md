# Material complementario — Sesión 12

## Introducción al OMOP CDM: Arquitectura y Tablas Clínicas

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Explicar qué problema resuelve un Common Data Model y por qué la industria lo adoptó
- Navegar las tablas centrales del OMOP CDM v5.4 y sus relaciones
- Escribir consultas básicas sobre PERSON, VISIT_OCCURRENCE y CONDITION_OCCURRENCE
- Distinguir entre concept_id estándar y source_value/source_concept_id

## Documentación esencial

- ★ [**The Book of OHDSI — Cap. 4: The Common Data Model**](https://ohdsi.github.io/TheBookOfOhdsi/CommonDataModel.html)
  ★ Lectura obligada de la sesión. Gratis, y es el mejor texto que existe sobre el tema.
- [**OMOP CDM v5.4 — Especificación de tablas**](https://ohdsi.github.io/CommonDataModel/cdm54.html)
  La referencia campo por campo. Tenla abierta siempre que escribas SQL sobre OMOP.
- [**OMOP CDM — Sitio de documentación**](https://ohdsi.github.io/CommonDataModel/)
  DDLs listos para varios motores, diagramas y notas de versión.
- [**CDM — Diagrama entidad-relación**](https://ohdsi.github.io/CommonDataModel/cdm54erd.html)
  El modelo completo en una imagen. Útil para comparar con tu diagrama de la actividad 4.
- [**THEMIS — convenciones de la comunidad**](https://ohdsi.github.io/Themis/)
  Las reglas acordadas de «y esto dónde va». Resuelve casi todas las dudas de ETL.

## Las tablas que más confunden

- ★ [**OBSERVATION_PERIOD**](https://ohdsi.github.io/CommonDataModel/cdm54.html#observation_period)
  La tabla que todos olvidan y que invalida más resultados. Léela entera: son dos párrafos.
- [**CONCEPT**](https://ohdsi.github.io/CommonDataModel/cdm54.html#concept)
  El corazón del modelo. Presta atención a `standard_concept` y a `domain_id`.
- [**MEASUREMENT contra OBSERVATION**](https://ohdsi.github.io/CommonDataModel/cdm54.html#measurement)
  La guía oficial de cuándo va en cada una. Los casos grises se aclaran en la sesión 13.
- [**Tipos de concepto (`*_type_concept_id`)**](https://athena.ohdsi.org/search-terms/terms?domain=Type+Concept)
  De dónde salió el dato: facturación, expediente, registro. Cambia cuánto le crees.

## Herramientas

- ★ [**ATHENA — Navegador de vocabularios**](https://athena.ohdsi.org/)
  ★ Buscar conceptos y descargar vocabularios. **Regístrate esta semana**: la descarga tarda.
- [**ATLAS — instancia pública de demostración**](https://atlas-demo.ohdsi.org/)
  Prueba la interfaz sin instalar nada, con usuario invitado.
- [**Eunomia**](https://github.com/OHDSI/Eunomia)
  Base OMOP de juguete en SQLite. Ideal para probar consultas sin montar infraestructura.
- [**Data Quality Dashboard**](https://ohdsi.github.io/DataQualityDashboard/)
  Más de 3 000 verificaciones automáticas sobre una base OMOP. El marco conceptual importa aunque no lo ejecutes.
- [**Achilles**](https://github.com/OHDSI/Achilles)
  Caracterización descriptiva automática: qué hay realmente en la base.

## Hacer el ETL

- ★ [**The Book of OHDSI — Cap. 6: Extract Transform Load**](https://ohdsi.github.io/TheBookOfOhdsi/ExtractTransformLoad.html)
  El proceso completo, con la metodología de mapeo. Léelo antes de la actividad 1.
- [**ETL-Synthea (OHDSI)**](https://github.com/OHDSI/ETL-Synthea)
  Paquete oficial de R que convierte Synthea a OMOP. La ruta más directa del laboratorio.
- [**dbt-synthea (OHDSI)**](https://github.com/OHDSI/dbt-synthea)
  El mismo ETL como proyecto de dbt, con tests y linaje. Si hiciste la sesión 11, esta es la ruta que más te enseña.
- [**Usagi**](https://github.com/OHDSI/Usagi)
  Mapeo asistido de códigos locales a conceptos estándar. Lo necesitarás si algún día conviertes datos reales.
- [**Tutorial ETL de OHDSI**](https://github.com/OHDSI/Tutorial-ETL)
  El material del tutorial oficial de la comunidad, con ejemplos.

## Comunidad y artículos

- ★ [**OHDSI Forums**](https://forums.ohdsi.org/)
  Donde se resuelven las dudas reales de ETL y vocabularios. Buscar antes de preguntar.
- [**OHDSI — Working Groups**](https://www.ohdsi.org/workgroups/)
  Grupos abiertos; **puedes unirte siendo estudiante**. Es la mejor puerta de entrada al campo.
- [**OHDSI en GitHub**](https://github.com/OHDSI)
  Todo el software es abierto. Leer el código de ETL-Synthea o CohortGenerator enseña mucho.
- [**OHDSI: Opportunities for Observational Researchers (Hripcsak et al., 2015)**](https://pubmed.ncbi.nlm.nih.gov/26262116/)
  El artículo fundacional. Corto y explica el porqué del proyecto.
- [**Validation of a common data model for active safety surveillance (Overhage et al.)**](https://doi.org/10.1136/jamia.2011.000376)
  Cómo se validó el modelo: la evidencia de que la conversión no destruye información.
- [**Canal de YouTube de OHDSI**](https://www.youtube.com/@OHDSI)
  Tutoriales completos de OMOP, ATLAS y estudios de red.

## Datos para practicar

- ★ [**Synthea**](https://synthetichealth.github.io/synthea/)
  El generador que vienes usando desde el laboratorio 2.
- [**CMS SynPUF en OMOP**](https://github.com/OHDSI/ETL-CMS)
  Datos sintéticos de Medicare ya convertidos. Estructura de claims más realista que Synthea.
- [**Synthea en OMOP, en AWS Open Data**](https://registry.opendata.aws/synthea-omop/)
  Conjuntos de 1 000, 100 000 y 2.8 millones de personas, ya en OMOP. Útil si quieres volumen sin convertir tú.
- [**Más fuentes de datos**](https://physionet.org/about/database/)
  Catálogo de PhysioNet. Ver también `docs/proyecto-final.md` del curso.


