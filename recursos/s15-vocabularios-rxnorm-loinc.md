# Material complementario — Sesión 15

## Vocabularios Estándar: RxNorm y LOINC

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Navegar la estructura de RxNorm: ingrediente, forma, dosis y producto empaquetado
- Interpretar un código LOINC a partir de sus seis ejes
- Traducir códigos locales de farmacia y laboratorio a estándares en OMOP
- Construir concept sets de fármacos y de analitos para una pregunta de investigación

## Empieza por aquí

- ★ [**RxNav**](https://mor.nlm.nih.gov/RxNav/)
  El navegador interactivo de RxNorm. Ábrelo, busca «metformin» y recorre los TTY: media hora aquí vale más que leer la documentación.
- [**LOINC — Get started guide**](https://loinc.org/get-started/)
  Los seis ejes explicados con ejemplos. Quince minutos, y después los códigos se leen solos.
- [**The Book of OHDSI — Cap. 5: Standardized Vocabularies**](https://ohdsi.github.io/TheBookOfOhdsi/StandardizedVocabularies.html)
  Las secciones de fármacos y de mediciones son la referencia de esta sesión.

## RxNorm

- ★ [**RxNorm — NLM**](https://www.nlm.nih.gov/research/umls/rxnorm/index.html)
  Página oficial: qué es, cómo se actualiza y cómo se licencia (gratis, con registro UMLS).
- [**RxNorm Technical Documentation**](https://www.nlm.nih.gov/research/umls/rxnorm/docs/techdoc.html)
  La referencia de los term types (IN, PIN, SCD, SBD, GPCK…) y de las relaciones entre ellos.
- [**RxNav — APIs**](https://lhncbc.nlm.nih.gov/RxNav/APIs/)
  API pública y sin llave. Con una sola llamada obtienes todos los productos de un ingrediente; úsala para verificar tu SQL.
- [**RxClass API**](https://lhncbc.nlm.nih.gov/RxNav/APIs/RxClassAPIs.html)
  Devuelve los miembros de una clase (ATC, MED-RT, MeSH). El atajo para comprobar que tu consulta de ATC no se dejó nada.
- [**RxNorm Extension (OHDSI)**](https://github.com/OHDSI/Vocabulary-v5.0)
  El vocabulario que OHDSI mantiene para medicamentos fuera de EUA. Es el que vas a necesitar con datos mexicanos.

## ATC y clasificaciones

- ★ [**Índice ATC/DDD (OMS)**](https://atcddd.fhi.no/atc_ddd_index/)
  El índice oficial: busca un código y ve sus cinco niveles y la dosis diaria definida.
- [**Estructura y principios de la clasificación ATC**](https://atcddd.fhi.no/atc/structure_and_principles/)
  Por qué un fármaco puede tener varios códigos ATC. Léelo antes de sorprenderte con eso en tu base.

## LOINC y unidades

- ★ [**LOINC — Sitio oficial**](https://loinc.org/)
  Descarga gratuita con registro.
- [**LOINC Search**](https://search.loinc.org/)
  El buscador oficial. Fíjate siempre en los seis ejes, no sólo en el nombre.
- [**LOINC Top 2000 lab observations**](https://loinc.org/usage/obs/)
  Los códigos que concentran la enorme mayoría de los resultados reales. Empieza aquí antes de buscar códigos exóticos.
- [**UCUM — Unified Code for Units of Measure**](https://ucum.org/)
  El estándar de unidades que OMOP usa en `unit_concept_id`. Consulta la especificación cuando una unidad te parezca rara.

## Mapear catálogos locales

- ★ [**Usagi**](https://github.com/OHDSI/Usagi)
  Propone candidatos por similitud de texto contra ATHENA. Propone: la decisión sigue siendo tuya.
- [**The Book of OHDSI — Cap. 6: Extract, Transform, Load**](https://ohdsi.github.io/TheBookOfOhdsi/ExtractTransformLoad.html)
  La metodología completa de mapeo, incluido el flujo con Usagi y `SOURCE_TO_CONCEPT_MAP`.
- [**UMLS — Unified Medical Language System**](https://www.nlm.nih.gov/research/umls/index.html)
  El metatesauro que conecta más de 200 vocabularios. Necesario sólo cuando OMOP no basta; licencia gratuita con registro.
- [**OHDSI Forums — Vocabulary Users**](https://forums.ohdsi.org/c/vocabulary-users/)
  Donde se discuten los mapeos dudosos. Busca antes de preguntar.

## México

- ★ [**Compendio Nacional de Insumos para la Salud (CSG)**](https://www.gob.mx/csg/articulos/compendio-nacional-de-insumos-para-la-salud-367182)
  El catálogo vigente del sistema de salud mexicano, sucesor del Cuadro Básico. Sus claves no son RxNorm: por eso es el mejor caso de práctica de mapeo que tienes a la mano.


