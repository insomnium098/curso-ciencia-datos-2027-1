# Material complementario — Sesión 18

## Cohortes Avanzadas: Feasibility, Attrition Tables y Herramientas OHDSI

*Bloque III — SQL y datos clínicos estandarizados*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Evaluar la factibilidad de un estudio antes de invertir meses en él
- Construir tablas de atrición que documenten cada paso de la definición
- Usar CohortDiagnostics para auditar una definición de cohorte
- Comprender cómo se ejecuta un estudio de red federado

## Empieza por aquí

- ★ [**The Book of OHDSI — Cap. 11: Characterization**](https://ohdsi.github.io/TheBookOfOhdsi/Characterization.html)
  Qué se reporta de una cohorte y por qué. Es el capítulo que acompaña al laboratorio.
- [**CohortDiagnostics**](https://ohdsi.github.io/CohortDiagnostics/)
  Es un paquete de R, pero lo que importa es **qué diagnostica**: esas mismas preguntas las puedes responder en SQL.
- [**Viewing results using Diagnostics Explorer**](https://ohdsi.github.io/CohortDiagnostics/articles/ViewingResultsUsingDiagnosticsExplorer.html)
  Pantalla por pantalla. La sección de conceptos huérfanos es la que replicas a mano en la actividad 7.

## ATLAS

- ★ [**ATLAS — demo pública**](https://atlas-demo.ohdsi.org/)
  Entra, construye una cohorte y exporta el SQL. Treinta minutos aquí valen por una clase entera. Ojo: trae datos sintéticos, no sirve para resultados.
- [**ATLAS — Cohort Definitions (wiki)**](https://github.com/OHDSI/Atlas/wiki/Cohort-Definitions)
  La semántica exacta de cada criterio de la interfaz. Úsalo como diccionario cuando traduzcas entre ATLAS y tu SQL.
- [**CIRCE**](https://github.com/OHDSI/circe-be)
  El compilador que convierte el JSON de la definición en SQL. Si quieres saber por qué el SQL generado es así, está aquí.
- [**OHDSI Phenotype Library**](https://github.com/OHDSI/PhenotypeLibrary)
  Definiciones publicadas como JSON. Es lo que hace portable una cohorte: descargas el JSON, no el SQL de nadie.

## Factibilidad y tamaño de muestra

- ★ [**Peduzzi P, et al. A simulation study of the number of events per variable in logistic regression analysis. *J Clin Epidemiol.* 1996;49(12):1373-1379.**](https://pubmed.ncbi.nlm.nih.gov/8970487/)
  El origen de la regla de ≥10 eventos por variable. Lo que importa es el principio: lo que limita no es el número de pacientes, es el de eventos.
- [**Riley RD, et al. Minimum sample size for developing a multivariable prediction model: PART II — binary and time-to-event outcomes. *Stat Med.* 2019;38(7):1276-1296.**](https://pubmed.ncbi.nlm.nih.gov/30357870/)
  La refinación moderna: en vez de un número fijo, calcular el mínimo según el modelo y el desenlace. Léelo cuando vayas a justificar el tamaño de tu estudio.

## El ecosistema HADES

- ★ [**HADES — Health Analytics Data-to-Evidence Suite**](https://ohdsi.github.io/Hades/)
  El catálogo completo de paquetes. No vamos a usarlos (son de R) pero es lo que vas a encontrar en la industria.
- [**FeatureExtraction**](https://ohdsi.github.io/FeatureExtraction/)
  Covariables estandarizadas desde el CDM, con ventanas temporales. Conceptualmente es la sesión 23 por adelantado.
- [**CohortGenerator**](https://ohdsi.github.io/CohortGenerator/)
  Generar cohortes de forma reproducible, pensado para estudios en red.
- [**Capr**](https://ohdsi.github.io/Capr/)
  Definir cohortes como código en vez de con la interfaz de ATLAS. Produce el mismo JSON.
- [**Strategus**](https://ohdsi.github.io/Strategus/)
  Empaqueta un estudio completo —cohortes, análisis y resultados— como algo instalable y ejecutable en otro sitio.

## Estudios de red

- ★ [**The Book of OHDSI — Cap. 18: OHDSI Network Research**](https://ohdsi.github.io/TheBookOfOhdsi/OhdsiNetworkResearch.html)
  Cómo funciona un estudio federado: qué viaja, qué no, y cómo se coordinan los sitios.
- [**LEGEND-HTN (Suchard et al., *Lancet* 2019;394:1816-1827)**](https://pubmed.ncbi.nlm.nih.gov/31668726/)
  El estudio de red de referencia: clases de antihipertensivos sobre 4.9 millones de pacientes en nueve bases de datos.
- [**LEGEND — visor de resultados**](https://data.ohdsi.org/LegendBasicViewer/)
  Explora los resultados del estudio anterior tú mismo. Da una idea muy concreta de qué produce un estudio de red.
- [**EHDEN — European Health Data & Evidence Network**](https://www.ehden.eu/)
  La red europea sobre OMOP: casos de uso, catálogo de fuentes y materiales de formación.

## Cómo se reporta

- ★ [**RECORD-PE (Langan et al., *BMJ* 2018;363:k3532)**](https://pmc.ncbi.nlm.nih.gov/articles/PMC6234471/)
  La extensión de RECORD para farmacoepidemiología, en acceso abierto. Quince ítems que son, básicamente, el índice de tu sección de métodos.
- [**RECORD-PE — checklist en PDF**](http://www.record-statement.org/Files/checklist-pe/RECORD-PE%20Checklist.pdf)
  La lista para marcar mientras escribes.
- [**EQUATOR Network**](https://www.equator-network.org/)
  El repositorio de todas las guías de reporte. Busca aquí antes de escribir cualquier artículo.



