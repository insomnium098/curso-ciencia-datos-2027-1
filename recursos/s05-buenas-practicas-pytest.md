# Material complementario — Sesión 05

## Buenas Prácticas de Programación y Testing con pytest

*Bloque II — Ingeniería de software para científicos*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Estructurar un proyecto de Python como paquete instalable en vez de una carpeta de notebooks sueltos
- Escribir funciones testeables: puras, pequeñas, con tipos y docstrings
- Diseñar pruebas con pytest: assert, fixtures, parametrización y cobertura
- Automatizar la calidad con ruff, black, mypy y pre-commit

## Documentación oficial

- ★ [**pytest — Get Started**](https://docs.pytest.org/en/stable/getting-started.html)
  
- [**pytest — Fixtures**](https://docs.pytest.org/en/stable/how-to/fixtures.html)
  Alcance, composición y `conftest.py`. Lo necesitas para la actividad 5 del laboratorio.
- [**pytest — Parametrize**](https://docs.pytest.org/en/stable/how-to/parametrize.html)
  Cómo convertir una tabla de casos en una suite de pruebas.
- [**pytest — Fixtures integradas**](https://docs.pytest.org/en/stable/reference/fixtures.html)
  `tmp_path`, `monkeypatch`, `capsys`: las que ya vienen y casi nadie usa.
- [**Ruff**](https://docs.astral.sh/ruff/)
  Linter y formateador. Reemplaza flake8, isort, black y pyupgrade.
- [**Ruff — catálogo de reglas**](https://docs.astral.sh/ruff/rules/)
  Qué revisa cada regla y por qué. Útil cuando no entiendes un error.
- [**mypy**](https://mypy.readthedocs.io/)
  Verificación estática de tipos.
- [**pre-commit**](https://pre-commit.com/)
  Hooks de git para calidad automática. Recuerda: el YAML declara, `pre-commit install` activa.
- [**pytest-cov / coverage.py**](https://coverage.readthedocs.io/)
  Medición de cobertura. Lee la sección sobre qué NO significa el porcentaje.

## Empaquetado: del notebook al paquete

- ★ [**Python Packaging — Escribir tu pyproject.toml**](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)
  La guía oficial, campo por campo. Es la referencia de la actividad 1.
- [**src layout contra flat layout**](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/)
  Por qué `src/` evita que tus pruebas importen la copia local sin instalar y pasen de mentira.
- [**PEP 621 — Metadatos en pyproject.toml**](https://peps.python.org/pep-0621/)
  El estándar detrás del archivo. Corto.
- [**Packaging Python Projects (tutorial)**](https://packaging.python.org/en/latest/tutorials/packaging-projects/)
  De cero a paquete instalable, paso a paso.
- [**uv (Astral)**](https://docs.astral.sh/uv/)
  Gestor de paquetes y proyectos ultrarrápido. Reemplaza pip/venv/poetry y genera lockfile.

## Guías de estilo

- ★ [**PEP 8 — Style Guide for Python Code**](https://peps.python.org/pep-0008/)
  El documento original. Léelo una vez en la vida; después deja que ruff lo aplique.
- [**Google Python Style Guide**](https://google.github.io/styleguide/pyguide.html)
  Más opinado y con muy buenas justificaciones. La sección de docstrings es la mejor que hay.
- [**PEP 257 — Docstring Conventions**](https://peps.python.org/pep-0257/)
  Cómo escribir docstrings.
- [**PEP 484 — Type Hints**](https://peps.python.org/pep-0484/)
  La base del tipado. Para consulta, no para leer de corrido.

## Por qué probar código científico

- ★ [**A Scientist's Nightmare: Software Problem Leads to Five Retractions (Science)**](https://www.science.org/doi/10.1126/science.314.5807.1856)
  El caso Chang, que abre la sesión: dos columnas invertidas, cinco artículos retractados. Léelo, son dos páginas.
- [**Good Enough Practices in Scientific Computing (PLOS Comput Biol)**](https://doi.org/10.1371/journal.pcbi.1005510)
  Wilson et al. Lectura obligada para cualquier científico que programe. Prioriza lo alcanzable sobre lo ideal.
- [**Best Practices for Scientific Computing (PLOS Biology)**](https://doi.org/10.1371/journal.pbio.1001745)
  El artículo hermano, más ambicioso.
- [**The Turing Way — Testing**](https://book.the-turing-way.org/reproducible-research/testing)
  Testing enfocado a investigación, con vocabulario de tipos de prueba.
- [**Testing and Continuous Integration (Software Carpentry)**](https://carpentries-incubator.github.io/python-testing/)
  Lección práctica pensada para científicos, no para desarrolladores web.

## Testing avanzado

- ★ [**Hypothesis — Documentación**](https://hypothesis.readthedocs.io/)
  Property-based testing: tú declaras la propiedad, él busca el contraejemplo y lo reduce al caso mínimo.
- [**¿Qué es property-based testing? (Hypothesis)**](https://hypothesis.works/articles/what-is-property-based-testing/)
  La explicación conceptual del autor. Empieza por aquí antes que por la documentación.
- [**Hypothesis — Estrategias**](https://hypothesis.readthedocs.io/en/latest/data.html)
  El catálogo de generadores: floats, integers, sampled_from, composición.
- [**Pandera**](https://pandera.readthedocs.io/)
  Validación de esquemas de DataFrames: el contrato de tus datos, ejecutable. Muy útil con datos clínicos.
- [**pandas.testing**](https://pandas.pydata.org/docs/reference/testing.html)
  `assert_frame_equal` y compañía: comparar DataFrames en pruebas sin sufrir.

## Libros y práctica

- ★ [**Python Testing with pytest, 2ª ed. (Brian Okken)**](https://pragprog.com/titles/bopytest2/python-testing-with-pytest-second-edition/)
  El libro de referencia sobre pytest. Práctico y directo.
- [**Real Python — Effective Testing with pytest**](https://realpython.com/pytest-python-testing/)
  Tutorial extenso y gratuito, buena alternativa al libro.
- [**PythonTest (Brian Okken)**](https://pythontest.com/)
  Blog del autor del libro, más el archivo del pódcast *Test & Code*. Artículos cortos sobre pytest y empaquetado.
- [**Architecture Patterns with Python**](https://www.cosmicpython.com/book/preface.html)
  Libro gratuito en línea. El capítulo sobre dependencias y I/O en los bordes es el que aplica a esta sesión.

