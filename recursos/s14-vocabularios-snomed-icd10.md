# Material complementario — Sesión 14

## Vocabularios Estándar: SNOMED CT e ICD-10

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Explicar la diferencia entre una terminología de referencia y una clasificación estadística
- Navegar SNOMED CT: jerarquías, atributos y expresiones post-coordinadas
- Mapear códigos ICD-10 a conceptos estándar SNOMED en OMOP
- Construir conjuntos de conceptos (concept sets) defendibles para una definición de enfermedad

## Empieza por aquí

- ★ [**The Book of OHDSI — Cap. 5: Standardized Vocabularies**](https://ohdsi.github.io/TheBookOfOhdsi/StandardizedVocabularies.html)
  El capítulo clave de esta sesión y de las dos siguientes. Si sólo lees una cosa, que sea ésta.
- [**ATHENA**](https://athena.ohdsi.org/)
  Búsqueda y descarga de vocabularios. Lo vas a tener abierto todo el laboratorio.
- [**SNOMED CT Browser**](https://browser.ihtsdotools.org/)
  Navegador oficial gratuito. Úsalo para ver la jerarquía y las relaciones de atributo que ATHENA no muestra tan bien.

## SNOMED CT

- ★ [**SNOMED International**](https://www.snomed.org/)
  Sitio oficial. México es país miembro, lo que da acceso a la licencia sin costo adicional.
- [**SNOMED CT Starter Guide**](https://confluence.ihtsdotools.org/display/DOCSTART)
  Guía introductoria oficial. Gratuita, corta y sorprendentemente clara.
- [**SNOMED CT — Five-Step Briefing**](https://www.snomed.org/five-step-briefing)
  Panorama de 15 minutos: qué es, para qué sirve y cómo se gobierna.
- [**SNOMED CT Editorial Guide**](https://confluence.ihtsdotools.org/display/DOCEG)
  Las reglas del modelo de conceptos. Consúltala cuando una jerarquía te parezca ilógica: casi siempre hay una regla detrás.

## ICD y CIE-10

- ★ [**ICD-10 — Navegador de la OMS**](https://icd.who.int/browse10/2019/en)
  Clasificación internacional oficial, la base de la que derivan todas las variantes nacionales.
- [**ICD-11 — Navegador de la OMS**](https://icd.who.int/browse/2024-01/mms/en)
  Vigente desde 2022. Todavía no domina los datos que vas a ver, pero conviene conocerla.
- [**CIE-10 en México (DGIS / Secretaría de Salud)**](http://www.dgis.salud.gob.mx/contenidos/intercambio/cie10_gobmx.html)
  Los catálogos oficiales que realmente se usan en el SINBA y en los egresos hospitalarios mexicanos.
- [**ICD-10-CM (CDC / NCHS)**](https://www.cdc.gov/nchs/icd/icd-10-cm/index.html)
  La variante de EUA, con ~70 000 códigos: la que verás en casi cualquier dataset de claims. Incluye un navegador gratuito en `icd10cmtool.cdc.gov`.

## Cómo se conectan en OMOP

- ★ [**OMOP CDM v5.4 — especificación de CONCEPT y CONCEPT_RELATIONSHIP**](https://ohdsi.github.io/CommonDataModel/cdm54.html)
  La definición formal de cada campo. Ten a mano la sección de vocabulario mientras escribes SQL.
- [**OHDSI Standardized Vocabularies (Reich et al., JAMIA 2024)**](https://pmc.ncbi.nlm.nih.gov/articles/PMC10873827/)
  Artículo de acceso abierto que explica cómo se construye y mantiene el vocabulario estándar: 10 millones de conceptos, 136 vocabularios.
- [**OHDSI — Vocabulary-v5.0 (GitHub)**](https://github.com/OHDSI/Vocabulary-v5.0)
  El código que genera los mapeos, con issues públicos. Cuando un mapeo te parezca mal, aquí se discute.
- [**OHDSI Forums — Vocabulary Users**](https://forums.ohdsi.org/c/vocabulary-users/)
  Donde se resuelven las dudas reales de mapeo. Busca antes de preguntar: casi siempre ya pasó.
- [**Usagi**](https://github.com/OHDSI/Usagi)
  Herramienta para mapear códigos locales a conceptos estándar cuando tu fuente no usa ICD-10 ni SNOMED.

## Definir y validar fenotipos

- ★ [**OHDSI Phenotype Library**](https://github.com/OHDSI/PhenotypeLibrary)
  Definiciones de cohortes revisadas por pares. Búscala aquí antes de inventar la tuya.
- [**The Book of OHDSI — Cap. 10: Defining Cohorts**](https://ohdsi.github.io/TheBookOfOhdsi/Cohorts.html)
  Metodología formal: cómo se escribe una definición que otro pueda reproducir.
- [**ATLAS demo pública**](https://atlas-demo.ohdsi.org/)
  Construye un concept set con interfaz gráfica y mira el JSON y el SQL que genera. Útil para entender qué estás escribiendo a mano.
- [**PheValuator (Swerdel, Hripcsak y Ryan, JBI 2019)**](https://pubmed.ncbi.nlm.nih.gov/31369862/)
  El método para estimar sensibilidad, especificidad y VPP de una definición sin revisar expedientes uno por uno.
- [**PheValuator — PDF de acceso libre**](https://www.ohdsi.org/wp-content/uploads/2019/09/Swerdel-PheValuator-Development-and-Evaluation-of-a-Phenotype-Algorithm-Evaluator.pdf)
  El artículo completo, alojado por OHDSI.
- [**PheValuator (código)**](https://github.com/OHDSI/PheValuator)
  El paquete de R, por si quieres aplicarlo a tu propio fenotipo.

