# Material complementario — Sesión 24

## Modelos Avanzados: Comparar Algoritmos e Hiperparámetros

*Bloque V — Machine Learning clínico*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Ubicar las familias de algoritmos y qué supone cada una sobre los datos
- Entrenar y regularizar modelos XGBoost y LightGBM
- Optimizar hiperparámetros con búsqueda bayesiana sin sobreajustar la validación
- Comparar honestamente modelos complejos contra baselines simples

## Empieza por aquí

- ★ [**XGBoost — Introduction to Boosted Trees**](https://xgboost.readthedocs.io/en/stable/tutorials/model.html)
  La mejor explicación conceptual del boosting que existe, y es corta. Léela antes de la clase.
- [**Grinsztajn L, Oyallon E, Varoquaux G. Why do tree-based models still outperform deep learning on tabular data? *NeurIPS* 2022.**](https://arxiv.org/abs/2207.08815)
  La evidencia, bien hecha: la ventaja no desaparece al ajustar hiperparámetros, las redes sufren con funciones irregulares, y la brecha **crece** cuando hay variables no informativas.
- [**LightGBM — Parameters Tuning**](https://lightgbm.readthedocs.io/en/stable/Parameters-Tuning.html)
  Recomendaciones prácticas, incluida la relación entre `num_leaves` y `max_depth`.

## Las familias de algoritmos

- ★ [**An Introduction to Statistical Learning (ISLP)**](https://www.statlearning.com/)
  Gratuito, con versión en Python. Capítulo 3 regresión lineal y múltiple, 4 logística, 8 árboles, 12 clustering. Es el mapa completo de esta sesión.
- [**scikit-learn — Supervised learning**](https://scikit-learn.org/stable/supervised_learning.html)
  El catálogo con la API de cada familia: lineales, vecinos, SVM, árboles y conjuntos.
- [**scikit-learn — Nearest Neighbors**](https://scikit-learn.org/stable/modules/neighbors.html)
  k-NN, con la advertencia sobre escalado y dimensionalidad.
- [**scikit-learn — Clustering**](https://scikit-learn.org/stable/modules/clustering.html)
  k-means, jerárquico y DBSCAN, con una tabla de cuándo sirve cada uno y cómo se evalúan.
- [**scikit-learn — Decision Trees**](https://scikit-learn.org/stable/modules/tree.html)
  Incluye la sección de ventajas y desventajas, donde está la inestabilidad del árbol único.

## Las librerías de boosting

- ★ [**XGBoost — documentación**](https://xgboost.readthedocs.io/en/stable/)
  Referencia completa, con la lista de parámetros y su efecto.
- [**LightGBM — documentación**](https://lightgbm.readthedocs.io/en/stable/)
  Más rápido con muchas filas; ojo con `num_leaves`.
- [**CatBoost**](https://catboost.ai/docs/)
  Manejo nativo y ordenado de categóricas. Útil con códigos clínicos de alta cardinalidad.
- [**Laurae++ — parámetros de XGBoost y LightGBM**](https://sites.google.com/view/lauraepp/parameters)
  Referencia cruzada entre ambas librerías: qué parámetro de una corresponde a cuál de la otra.
- [**Chen T, Guestrin C. XGBoost: A Scalable Tree Boosting System. *KDD* 2016.**](https://arxiv.org/abs/1603.02754)
  El artículo original. La sección de la función objetivo explica de dónde sale cada término de regularización.

## Buscar hiperparámetros

- ★ [**Optuna — documentación**](https://optuna.readthedocs.io/en/stable/)
  El tutorial de diez minutos alcanza para todo lo del laboratorio.
- [**Bergstra J, Bengio Y. Random Search for Hyper-Parameter Optimization. *JMLR* 2012;13:281-305.**](https://www.jmlr.org/papers/v13/bergstra12a.html)
  Por qué random search le gana a grid con el mismo presupuesto. Su figura 1 es la que reproducimos en clase.
- [**Bergstra J, et al. Algorithms for Hyper-Parameter Optimization. *NeurIPS* 2011.**](https://papers.nips.cc/paper_files/paper/2011/hash/86e8f7ab32cfd12577bc2619bc635690-Abstract.html)
  TPE, el algoritmo que Optuna usa por defecto.
- [**scikit-learn — Tuning hyper-parameters**](https://scikit-learn.org/stable/modules/grid_search.html)
  Incluye *successive halving*, que descarta temprano las configuraciones malas.
- [**scikit-learn — Nested cross-validation**](https://scikit-learn.org/stable/auto_examples/model_selection/plot_nested_cross_validation_iris.html)
  El ejemplo que muestra, con números, cuánto optimismo mete la CV simple cuando además buscas hiperparámetros.

## Registrar y reproducir

- ★ [**scikit-survival**](https://scikit-survival.readthedocs.io/)
  Modelos de supervivencia con la misma API de sklearn: Cox, Random Survival Forest y boosting de supervivencia. Para la parte opcional del laboratorio.
- [**Ishwaran H, et al. Random survival forests. *Ann Appl Stat.* 2008;2(3):841-860.**](https://arxiv.org/abs/0811.1645)
  El artículo original, en acceso abierto. Extiende los bosques aleatorios a datos censurados por la derecha.
- [**MLflow — Tracking**](https://mlflow.org/docs/latest/tracking.html)
  Corre local, sin servidor: `mlflow ui` y listo.
- [**scikit-learn — Controlar la aleatoriedad**](https://scikit-learn.org/stable/common_pitfalls.html#controlling-randomness)
  Cómo fijar las semillas para que el resultado se reproduzca de verdad.

## Práctica guiada

- ★ [**Kaggle Learn — Intermediate Machine Learning**](https://www.kaggle.com/learn/intermediate-machine-learning)
  Micro-curso gratuito con XGBoost, pipelines y validación cruzada. Dos horas bien invertidas si llegas en frío.


