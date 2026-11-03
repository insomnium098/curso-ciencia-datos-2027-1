# Material complementario — Sesión 25

## Evaluación Clínica: Calibración, Umbral y Utilidad

*Bloque V — Machine Learning clínico*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Explicar por qué el VPP depende de la población y no sólo del modelo
- Evaluar y corregir la calibración de un modelo de riesgo
- Aplicar análisis de curva de decisión para valorar utilidad clínica
- Leer beeswarm, waterfall y dependence, y reconocer los límites de la explicación post-hoc

## Empieza por aquí

- ★ [**Van Calster B, et al. Calibration: the Achilles heel of predictive analytics. *BMC Med.* 2019;17:230.**](https://link.springer.com/article/10.1186/s12916-019-1466-7)
  **El artículo de la sesión.** Por qué la calibración importa tanto como la discriminación y se reporta mucho menos. Acceso abierto, y corto.
- [**Vickers AJ, Van Calster B, Steyerberg EW. Net benefit approaches to the evaluation of prediction models, molecular markers, and diagnostic tests. *BMJ.* 2016;352:i6.**](https://doi.org/10.1136/bmj.i6)
  De dónde sale el beneficio neto: poner beneficios y daños en la misma escala mediante el umbral.
- [**Una guía paso a paso para interpretar una curva de decisión**](https://pmc.ncbi.nlm.nih.gov/articles/PMC6777022/)
  Vickers et al., *Diagn Progn Res* 2019. Más accesible que el original; léelo antes del laboratorio.

## Métricas y calibración

- ★ [**scikit-learn — Metrics and scoring**](https://scikit-learn.org/stable/modules/model_evaluation.html)
  El catálogo completo, con fórmulas.
- [**scikit-learn — Probability calibration**](https://scikit-learn.org/stable/modules/calibration.html)
  Platt e isotónica, con ejemplos gráficos y la advertencia de usar datos no vistos.
- [**Saito T, Rehmsmeier M. The precision-recall plot is more informative than the ROC plot when evaluating binary classifiers on imbalanced datasets. *PLoS One.* 2015;10(3):e0118432.**](https://doi.org/10.1371/journal.pone.0118432)
  Cuándo AUPRC y no AUROC, con el argumento desarrollado.

## Utilidad clínica

- ★ [**Decision Curve Analysis**](https://www.decisioncurveanalysis.org/)
  Sitio oficial con tutoriales y código en Python, R y Stata. Lo que vas a usar en el laboratorio.

## Interpretabilidad

- ★ [**SHAP — documentación**](https://shap.readthedocs.io/en/latest/)
  Con muchos ejemplos. Para modelos de árboles, `TreeExplainer`: exacto y rápido.
- [**Interpretable Machine Learning (Molnar)**](https://christophm.github.io/interpretable-ml-book/)
  Libro gratuito en línea. El capítulo de SHAP explica los valores de Shapley sin dar por hecho teoría de juegos.
- [**Rudin C. Stop explaining black box machine learning models for high stakes decisions and use interpretable models instead. *Nat Mach Intell.* 2019;1:206-215.**](https://arxiv.org/abs/1811.10154)
  El contrapunto crítico obligatorio. Posición fuerte y bien argumentada: para decisiones de alto riesgo, interpretable por diseño.

## Reporte y equidad

- ★ [**TRIPOD+AI (Collins GS, et al. *BMJ.* 2024;385:e078378)**](https://pmc.ncbi.nlm.nih.gov/articles/PMC11025451/)
  El checklist de reporte vigente, 27 ítems. Es el entregable del laboratorio.
- [**Obermeyer Z, et al. Dissecting racial bias in an algorithm used to manage the health of populations. *Science.* 2019;366(6464):447-453.**](https://doi.org/10.1126/science.aax2342)
  El caso de sesgo algorítmico más citado en salud. El sesgo no estaba en el modelo ni en los datos: estaba en haber elegido el **gasto** como sustituto de la **necesidad**.
- [**Riley RD, et al. Evaluation of clinical prediction models (part 1): from development to external validation. *BMJ.* 2024;384:e074819.**](https://pmc.ncbi.nlm.nih.gov/articles/PMC10772854/)
  Primera de una serie de tres sobre validación externa: qué evaluar, cómo hacerla y cuánta muestra hace falta.

## Cómo usar este material

1. **Antes de la clase:** revisa los recursos marcados con ★ (30–45 min).
2. **Durante el laboratorio:** ten abiertas las páginas de documentación oficial.
3. **Después:** elige un recurso de profundización relacionado con tu proyecto final.

## Enlaces del curso

- Diapositivas: [`slides/s25-evaluacion-clinica-shap.md`](../slides/s25-evaluacion-clinica-shap.md)
- Laboratorio: [`labs/s25-evaluacion-clinica-shap/`](../labs/s25-evaluacion-clinica-shap/)
- Temario completo: [`README.md`](../README.md)

---

¿Encontraste un recurso mejor? Abre un *issue* o un *pull request*: este material se mejora con las aportaciones del grupo.

