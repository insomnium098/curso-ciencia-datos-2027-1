# Material complementario — Sesión 22

## Machine Learning: Fundamentos, Flujo de Trabajo y scikit-learn

*Bloque V — Machine Learning clínico*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Distinguir predicción de inferencia causal y saber cuál necesita tu pregunta
- Ejecutar el flujo completo de ML: partición, entrenamiento, validación, evaluación
- Construir Pipelines de scikit-learn que eviten fuga de información
- Elegir esquemas de validación adecuados a datos clínicos agrupados y temporales

## Documentación

- ★ [**scikit-learn — User Guide**](https://scikit-learn.org/stable/user_guide.html)
  La documentación de referencia. Es también un buen libro de texto.
- [**scikit-learn — Common pitfalls**](https://scikit-learn.org/stable/common_pitfalls.html)
  Fuga de información, aleatoriedad e interpretación. Léelo entero.
- [**scikit-learn — Cross-validation**](https://scikit-learn.org/stable/modules/cross_validation.html)
  Todos los esquemas, con diagramas.
- [**scikit-learn — Pipelines**](https://scikit-learn.org/stable/modules/compose.html)
  La herramienta que previene la mayoría de los errores.

## Cursos y libros

- ★ [**An Introduction to Statistical Learning (ISLP, Python)**](https://www.statlearning.com/)
  Libro gratuito en PDF, con versión en Python. El mejor punto de entrada teórico.
- [**Google — Machine Learning Crash Course**](https://developers.google.com/machine-learning/crash-course)
  Gratis, práctico, bien hecho.
- [**Hands-On Machine Learning (Géron, 3ª ed.)**](https://www.oreilly.com/library/view/hands-on-machine-learning/9781098125967/)
  El libro práctico más recomendado del campo.
- [**scikit-learn MOOC (Inria)**](https://inria.github.io/scikit-learn-mooc/)
  Curso completo gratuito hecho por los desarrolladores.

## Fuga de información

- ★ [**Kapoor S, Narayanan A. Leakage and the reproducibility crisis in machine-learning-based science. *Patterns.* 2023;4(9):100804.**](https://www.cell.com/patterns/fulltext/S2666-3899(23)00159-9)
  **Léelo.** Encontraron fuga en 294 artículos de 17 campos, proponen una taxonomía de ocho tipos y unas «model info sheets» para revisarlos. Acceso abierto.
- [**scikit-learn — Common pitfalls and recommended practices**](https://scikit-learn.org/stable/common_pitfalls.html)
  Fuga, aleatoriedad e interpretación, con ejemplos de código correcto e incorrecto. Léelo entero: son veinte minutos.

## ML clínico específicamente

- ★ [**TRIPOD+AI (Collins GS, et al. *BMJ.* 2024;385:e078378)**](https://pmc.ncbi.nlm.nih.gov/articles/PMC11025451/)
  Cómo se reporta un modelo de predicción clínica: 27 ítems, agnósticos al método. Acceso abierto. Es la guía que te van a pedir si publicas.
- [**PROBAST**](https://www.probast.org/)
  La herramienta con la que un revisor va a evaluar el riesgo de sesgo de tu modelo. Conviene conocerla antes.
- [**Steyerberg EW, Harrell FE. Prediction models need appropriate internal, internal-external, and external validation. *J Clin Epidemiol.* 2016;69:245-247.**](https://pmc.ncbi.nlm.nih.gov/articles/PMC5578404/)
  Tres clases de validación que miden cosas distintas. Dos páginas, acceso abierto.
- [**Rajkomar A, Dean J, Kohane I. Machine Learning in Medicine. *N Engl J Med.* 2019;380(14):1347-1358.**](https://doi.org/10.1056/NEJMra1814259)
  Panorama accesible y crítico del campo.

