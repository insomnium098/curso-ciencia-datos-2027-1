# Material complementario — Sesión 06

## Ambientes Virtuales, Dependencias y Docker

*Bloque II — Ingeniería de software para científicos*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Aislar dependencias con venv/uv/conda y decidir cuál conviene en cada contexto
- Distinguir entre fijar versiones (pinning) y declarar restricciones, y usar lockfiles
- Escribir un Dockerfile correcto para un proyecto de ciencia de datos
- Construir, etiquetar y publicar imágenes reproducibles

## Documentación oficial

- ★ [**Docker — Get started**](https://docs.docker.com/get-started/)
  Ruta oficial de aprendizaje, bien hecha.
- [**Dockerfile reference**](https://docs.docker.com/reference/dockerfile/)
  La referencia que consultarás siempre.
- [**Docker — Building best practices**](https://docs.docker.com/build/building/best-practices/)
  Lectura obligada antes de escribir tu segundo Dockerfile.

## Gestión de dependencias

- ★ [**uv — Documentación**](https://docs.astral.sh/uv/)
  El estándar emergente. Rápido y bien diseñado.
- [**Python Packaging User Guide**](https://packaging.python.org/en/latest/)
  La guía oficial de PyPA sobre empaquetado y dependencias.
- [**pyproject.toml — especificación**](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/)
  Cómo escribirlo bien.
- [**Miniforge / mamba**](https://github.com/conda-forge/miniforge)
  conda-forge sin las restricciones de licencia de Anaconda.

## Artículos y libros

- ★ [**Ten Simple Rules for Writing Dockerfiles for Reproducible Data Science (PLOS Comput Biol)**](https://doi.org/10.1371/journal.pcbi.1008316)
  Nüst et al. Directo al grano y orientado a ciencia.
- [**Docker: Up & Running, 3rd ed. (Kane & Matthias)**](https://www.oreilly.com/library/view/docker-up/9781098131814/)
  Bibliografía base del curso.
- [**The Turing Way — Reproducible Environments**](https://book.the-turing-way.org/reproducible-research/renv)
  Panorama de opciones con criterios de decisión.

## Contenedores en ciencias de la vida

- ★ [**BioContainers**](https://biocontainers.pro/)
  Miles de herramientas bioinformáticas ya containerizadas.
- [**The Rocker Project**](https://rocker-project.org/)
  Imágenes de R/RStudio versionadas. El referente de buenas prácticas.
- [**Apptainer (antes Singularity)**](https://apptainer.org/docs/user/main/)
  Contenedores en HPC sin privilegios de root.

## Seguridad

- ★ [**Trivy**](https://trivy.dev/)
  Escáner de vulnerabilidades para imágenes, de código abierto.
- [**Docker Scout**](https://docs.docker.com/scout/)
  Análisis de seguridad integrado en Docker.

## Cómo usar este material

1. **Antes de la clase:** revisa los recursos marcados con ★ (30–45 min).
2. **Durante el laboratorio:** ten abiertas las páginas de documentación oficial.
3. **Después:** elige un recurso de profundización relacionado con tu proyecto final.


