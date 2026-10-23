# Material complementario — Sesión 23

## Feature Engineering con Datos Clínicos

*Bloque V — Machine Learning clínico*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Derivar variables predictivas clínicamente sensatas a partir de datos longitudinales OMOP
- Manejar variables categóricas de alta cardinalidad, series temporales y datos faltantes
- Respetar ventanas temporales para evitar fuga y garantizar aplicabilidad clínica
- Documentar y versionar la definición de cada feature

## Empieza por aquí

- ★ [**Feature Engineering and Selection (Kuhn & Johnson)**](https://bookdown.org/max/FES/)
  Libro gratuito en línea. Lo mejor que existe sobre **por qué** cada transformación, no sólo cómo. Los capítulos de codificación y de faltantes son los de hoy.
- [**scikit-learn — Preprocessing data**](https://scikit-learn.org/stable/modules/preprocessing.html)
  Escalado, codificación y discretización, con la advertencia de qué modelos lo necesitan y cuáles no.
- [**OHDSI FeatureExtraction**](https://ohdsi.github.io/FeatureExtraction/)
  Covariables estandarizadas desde OMOP, con ventanas declaradas. Aunque es R, su **catálogo de covariables** es la mejor lista de ideas que vas a encontrar.

## Construir las variables

- ★ [**Feature-engine**](https://feature-engine.trainindata.com/)
  Transformadores compatibles con `Pipeline` para cosas que sklearn no trae: agrupar categorías raras, winsorizar, codificar por frecuencia.
- [**scikit-learn — Imputation**](https://scikit-learn.org/stable/modules/impute.html)
  `SimpleImputer`, `IterativeImputer` y `MissingIndicator`. Este último es el de «imputar **y** marcar que faltaba».
- [**scikit-learn — ColumnTransformer**](https://scikit-learn.org/stable/modules/compose.html)
  Tratamientos distintos para numéricas y categóricas, dentro del mismo Pipeline.

## Índices clínicos

- ★ [**Quan H, et al. Coding algorithms for defining comorbidities in ICD-9-CM and ICD-10 administrative data. *Med Care.* 2005;43(11):1130-1139.**](https://pubmed.ncbi.nlm.nih.gov/16224307/)
  **La** referencia para calcular Charlson y Elixhauser desde códigos. Trae los algoritmos para ICD-9-CM e ICD-10.
- [**Inker LA, et al. New Creatinine- and Cystatin C-Based Equations to Estimate GFR without Race. *N Engl J Med.* 2021;385(19):1737-1749.**](https://doi.org/10.1056/NEJMoa2102953)
  La ecuación CKD-EPI **de 2021**, sin coeficiente racial. Es la vigente: si usas una anterior, justifícalo.
- [**MDCalc**](https://www.mdcalc.com/)
  Catálogo de scores clínicos validados, cada uno con su referencia original. Búscalo aquí antes de inventar tu propio índice.

## Datos faltantes

- ★ [**Flexible Imputation of Missing Data (van Buuren)**](https://stefvanbuuren.name/fimd/)
  El libro del campo, gratuito y completo. El capítulo 1 explica MCAR, MAR y MNAR mejor que nadie.
- [**Sterne JAC, et al. Multiple imputation for missing data in epidemiological and clinical research: potential and pitfalls. *BMJ.* 2009;338:b2393.**](https://doi.org/10.1136/bmj.b2393)
  Guía práctica corta. Es lo que te va a pedir una revista si imputas.

## Metodología y reporte

- ★ [**TRIPOD+AI (Collins GS, et al. *BMJ.* 2024;385:e078378)**](https://pmc.ncbi.nlm.nih.gov/articles/PMC11025451/)
  Qué tienes que reportar sobre tus predictores: definición, ventana, manejo de faltantes. Tu diccionario de datos debería responder a esto.
- [**Feast — feature store**](https://docs.feast.dev/)
  El concepto de *feature store*: definiciones de variables versionadas y compartidas entre proyectos. Es cómo la industria evita que «polifarmacia» signifique cinco cosas distintas.


