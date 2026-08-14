# Material complementario — Sesión 02

## Python para Biomedicina: Estructuras de Datos y Pandas

*Bloque I — Fundamentos de Python para datos biomédicos*

## Objetivos que apoya este material

- Elegir la estructura de datos correcta según el problema y su costo en memoria y en tiempo
- Explicar por qué Python consume tanta memoria, y reducir el consumo de un DataFrame eligiendo bien los dtypes
- Manipular datos tabulares clínicos con pandas: selección, filtrado, agrupación y joins
- Reconocer cuándo pandas deja de alcanzar y por qué la industria usa Spark (PySpark)

## Documentación oficial

- ★ [**pandas — 10 minutes to pandas**](https://pandas.pydata.org/docs/user_guide/10min.html)
  El punto de entrada canónico. Léelo entero, son 20 minutos reales.
- [**pandas — User Guide**](https://pandas.pydata.org/docs/user_guide/index.html)
  Referencia completa. Los capítulos de Merge, GroupBy y Reshaping son los que más usarás.
- [**pandas — Comparison with SQL**](https://pandas.pydata.org/docs/getting_started/comparison/comparison_with_sql.html)
  Traducción directa entre SQL y pandas. Muy útil para el bloque III.

## Tutoriales y cursos

- ★ [**Real Python — pandas**](https://realpython.com/learning-paths/pandas-data-science/)
  Ruta de aprendizaje bien escrita, con ejercicios.
- [**Kaggle — Pandas (micro-curso)**](https://www.kaggle.com/learn/pandas)
  4 horas, gratis, con ejercicios autoevaluables.
- [**Python Data Science Handbook (Jake VanderPlas)**](https://jakevdp.github.io/PythonDataScienceHandbook/)
  Libro completo gratis en línea. Capítulo 3 = pandas.

## Estilo y buenas prácticas

- ★ [**Effective Pandas (Matt Harrison) — charla**](https://www.youtube.com/watch?v=zgbUk90aQ6A)
  Cambia por completo cómo escribes pandas. Method chaining explicado bien.
- [**Modern Pandas (Tom Augspurger)**](https://tomaugspurger.net/posts/modern-1-intro/)
  Serie de 8 posts del core developer de pandas. Idiomas modernos del API.

## Memoria y rendimiento

- ★ [**Apache Arrow and the '10 Things I Hate About pandas' (Wes McKinney)**](https://wesmckinney.com/blog/apache-arrow-pandas-internals/)
  El creador de pandas explica sus problemas de memoria y por qué necesita 5–10× el tamaño del dataset en RAM. Lectura clave de esta sesión.
- [**pandas — Scaling to large datasets**](https://pandas.pydata.org/docs/user_guide/scale.html)
  Guía oficial: dtypes eficientes, chunking y cuándo cambiar de herramienta.
- [**Python — sys.getsizeof y el modelo de objetos**](https://docs.python.org/3/library/sys.html#sys.getsizeof)
  Para medir tú mismo el sobrecosto de cada objeto.
- [**High Performance Python (Gorelick & Ozsvald, O'Reilly)**](https://www.oreilly.com/library/view/high-performance-python/9781492055013/)
  Capítulos 3, 6 y 11: estructuras de datos, matrices y uso de memoria.
- [**Python's GIL — documentación oficial**](https://docs.python.org/3/glossary.html#term-global-interpreter-lock)
  Por qué añadir hilos no acelera trabajo intensivo en CPU.

## Cuando pandas ya no alcanza

- ★ [**PySpark — Documentación oficial**](https://spark.apache.org/docs/latest/api/python/index.html)
  La API de Python de Spark. Empieza por el 'Quickstart: DataFrame'.
- [**Learning Spark, 2ª ed. (Damji et al.)**](https://www.databricks.com/resources/ebook/learning-spark-from-disk-to-memory)
  Libro completo y gratuito publicado por Databricks. La referencia introductoria.
- [**Spark SQL — Performance tuning**](https://spark.apache.org/docs/latest/sql-performance-tuning.html)
  Particiones, shuffles y broadcast joins: lo que determina si tu job tarda 2 minutos o 2 horas.
- [**pandas API on Spark**](https://spark.apache.org/docs/latest/api/python/user_guide/pandas_on_spark/index.html)
  Escribir código con sintaxis de pandas que se ejecuta distribuido. Útil para migrar sin reescribir todo.
- [**Apache Arrow en PySpark (pandas UDFs)**](https://spark.apache.org/docs/latest/api/python/user_guide/sql/arrow_pandas.html)
  Por qué una UDF de Python es lenta y cómo Arrow reduce el costo de serialización.
- [**Polars — User Guide**](https://docs.pola.rs/)
  Alternativa en Rust, mucho más rápida y con menos memoria que pandas. Un solo equipo, hasta cientos de GB.
- [**DuckDB**](https://duckdb.org/docs/)
  SQL sobre Parquet/CSV sin servidor. Lo usaremos en el bloque III.
- [**Big Data is Dead (Jordan Tigani, MotherDuck)**](https://motherduck.com/blog/big-data-is-dead/)
  Argumento contrario, bien fundamentado: la mayoría de las empresas nunca tuvo datos que justificaran un clúster. Léelo antes de proponer Spark.

## Datos para practicar

- ★ [**Synthea — Synthetic Patient Records**](https://synthetichealth.github.io/synthea/)
  Generador de pacientes sintéticos realistas. Fuente de los datos del curso.
- [**PhysioNet**](https://physionet.org/)
  Repositorio de datos clínicos (MIMIC, eICU). Requiere entrenamiento CITI para los datos restringidos.

## Cómo usar este material

1. **Antes de la clase:** revisa los recursos marcados con ★ (30–45 min).
2. **Durante el laboratorio:** ten abiertas las páginas de documentación oficial.
3. **Después:** elige un recurso de profundización relacionado con tu proyecto final.

---

¿Encontraste un recurso mejor? Abre un *issue* o un *pull request*: este material se mejora con las aportaciones del grupo.

