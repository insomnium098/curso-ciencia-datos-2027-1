# Material complementario — Sesión 03

## Python para Biomedicina: Visualización y Análisis Exploratorio

*Bloque I — Fundamentos de Python para datos biomédicos*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Ejecutar un EDA sistemático sobre un dataset clínico desconocido
- Elegir el tipo de gráfica correcto según el tipo de variable y la pregunta
- Construir figuras con matplotlib/seaborn que sean legibles y publicables
- Detectar problemas de calidad de datos que sólo se ven graficando

## Documentación oficial

- ★ [**matplotlib — Quick start guide**](https://matplotlib.org/stable/users/explain/quick_start.html)
  Empieza aquí. Explica bien Figure vs. Axes.
- [**seaborn — User guide and tutorial**](https://seaborn.pydata.org/tutorial.html)
  Tutorial excelente, especialmente la sección de 'Overview of plotting functions'.
- [**Plotly Python — Fundamentals**](https://plotly.com/python/)
  Galería con código para cada tipo de gráfica interactiva.

## Libros abiertos

- ★ [**Fundamentals of Data Visualization (Claus Wilke)**](https://clauswilke.com/dataviz/)
  Libro completo gratis. El estándar de facto sobre qué gráfica usar y por qué.
- [**Data Visualization: A Practical Introduction (Kieran Healy)**](https://socviz.co/)
  Gratis en línea. Muy bueno en el 'por qué' de las decisiones de diseño.

## Referencia de decisión

- ★ [**From Data to Viz**](https://www.data-to-viz.com/)
  Árbol de decisión interactivo: qué gráfica corresponde a tus datos, con código y con las trampas de cada una.
- [**The Python Graph Gallery**](https://python-graph-gallery.com/)
  Cientos de ejemplos con código copiable.

## Color y accesibilidad

- ★ [**ColorBrewer 2.0**](https://colorbrewer2.org/)
  Paletas diseñadas para datos, con filtros de accesibilidad e impresión.
- [**matplotlib — Choosing colormaps**](https://matplotlib.org/stable/users/explain/colors/colormaps.html)
  Por qué viridis y no jet, con la evidencia perceptual.

## Específico de salud

- ★ [**lifelines — Survival analysis in Python**](https://lifelines.readthedocs.io/)
  Kaplan-Meier, Cox y las gráficas asociadas. Incluye la tabla de pacientes en riesgo.
- [**Ten Simple Rules for Better Figures (PLOS Comput Biol)**](https://doi.org/10.1371/journal.pcbi.1003833)
  Artículo corto y clásico. Léelo antes de tu próxima figura de tesis.
- [**tableone**](https://pypi.org/project/tableone/)
  Genera la tabla de características basales (Tabla 1) que exige casi toda revista clínica.
- [**SAGER / EQUATOR — guías de reporte**](https://www.equator-network.org/)
  Qué figuras y tablas exige cada tipo de estudio.

## El clásico de Anscombe

- ★ [**Same Stats, Different Graphs: the Datasaurus Dozen (Matejka & Fitzmaurice, CHI 2017)**](https://www.research.autodesk.com/publications/same-stats-different-graphs/)
  13 datasets con estadísticos idénticos y formas radicalmente distintas. Con el código para generarlos.
- [**seaborn — dataset de Anscombe**](https://seaborn.pydata.org/generated/seaborn.load_dataset.html)
  `sns.load_dataset('anscombe')`: reprodúcelo tú en cinco líneas.

## EDA automatizado

- ★ [**ydata-profiling**](https://docs.profiling.ydata.ai/)
  Reporte exploratorio automático. Punto de partida, nunca entregable.
- [**skimpy**](https://github.com/aeturrell/skimpy)
  Resumen compacto de un DataFrame en la terminal. Más ligero que profiling.

## Cómo usar este material

1. **Antes de la clase:** revisa los recursos marcados con ★ (30–45 min).
2. **Durante el laboratorio:** ten abiertas las páginas de documentación oficial.
3. **Después:** elige un recurso de profundización relacionado con tu proyecto final.

