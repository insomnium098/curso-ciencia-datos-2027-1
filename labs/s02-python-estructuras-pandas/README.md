# Laboratorio 02 — Análisis de un dataset de pacientes, con presupuesto de memoria

**Sesión 02:** Python para Biomedicina: Estructuras de Datos y Pandas
**Bloque:** I — Fundamentos de Python para datos biomédicos

## Objetivo

Cargar, limpiar y analizar un dataset sintético tipo EHR **midiendo el costo en memoria de
cada decisión**, y comprobar en tu propia máquina dónde deja de alcanzar pandas.

No es un laboratorio de pandas. Es un laboratorio de *criterio*: al final debes poder
defender por qué elegiste cada dtype y cada herramienta.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas numpy pyarrow polars pyspark`

> **Aviso sobre Colab:** la sesión se reinicia y pierdes los datos descargados. Guarda los
> CSV en tu Drive o vuelve a descargarlos al inicio. PySpark funciona en Colab, pero es
> lento de arrancar: cuenta con un par de minutos.


---

## Los datos

Vas a usar **Synthea**, un generador de pacientes sintéticos con historias clínicas
longitudinales coherentes. Es el mismo dataset que te será de utilidad en los próximos laboratorios.

Elige una de las dos rutas.

### Ruta 1 — Descargar los datos de muestra (~1000 pacientes)

Synthea publica datasets ya generados en CSV. Descarga la muestra de
[synthea.mitre.org/downloads](https://synthea.mitre.org/downloads) o de
[la página del proyecto](https://synthetichealth.github.io/synthea/).

Sirve para todas las actividades salvo la 7, donde necesitas volumen de verdad.

### Ruta 2 — Generarlos tú (recomendada, el volumen lo eliges tú)

Requiere **Java 11 o superior**. Descarga el `.jar` con dependencias desde el
[repositorio de Synthea](https://github.com/synthetichealth/synthea) y consulta su
[guía de inicio](https://github.com/synthetichealth/synthea/wiki/Basic-Setup-and-Running).

Genera **al menos 20 000 pacientes** con salida en CSV. Con menos, el ejercicio de memoria
no se siente: los números salen tan pequeños que cualquier decisión parece dar igual.

> Averigua tú los parámetros exactos del comando y qué opción activa la exportación a CSV.
> Está documentado en la wiki de Synthea. Anota en tu notebook el comando que usaste:
> forma parte de la reproducibilidad de tu trabajo.

### Qué archivos vas a usar

De todo lo que genera Synthea, este laboratorio usa tres:

| Archivo | Es | Aprox. filas por paciente |
|---|---|---|
| `patients.csv` | Un renglón por paciente: demografía | 1 |
| `encounters.csv` | Encuentros clínicos (visitas) | 10–60 |
| `observations.csv` | Mediciones: laboratorios y signos vitales | 100–800 |

`observations.csv` es el archivo grande y el interesante para este laboratorio.

**Columnas principales** (verifica siempre contra el
[diccionario de datos oficial](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary),
que es la fuente de verdad y puede cambiar entre versiones):

- `patients.csv` → `Id`, `BIRTHDATE`, `DEATHDATE`, `GENDER`, `RACE`, `ETHNICITY`, `CITY`, `STATE`
- `encounters.csv` → `Id`, `START`, `STOP`, `PATIENT`, `ENCOUNTERCLASS`, `CODE`, `DESCRIPTION`
- `observations.csv` → `DATE`, `PATIENT`, `ENCOUNTER`, `CODE`, `DESCRIPTION`, `VALUE`, `UNITS`, `TYPE`

> **Fíjate en `VALUE` de `observations.csv`.** Synthea la exporta como texto, porque mezcla
> resultados numéricos con categóricos. Decidir qué hacer con esa columna es una de las
> decisiones importantes del laboratorio.

---

## Actividades

### 1. Carga con dtypes explícitos

Carga los tres archivos. La primera vez, **déjalos como pandas los infiera** y anota el
consumo de memoria de cada uno. Después vuelve a cargarlos declarando los dtypes.

Antes de escribir nada, responde en tu notebook: ¿qué columnas de `patients.csv` son
identificadores, cuáles categóricas y cuáles fechas? La respuesta determina tus dtypes.

**Entrega:** una tabla con el consumo antes y después, por archivo.

**Pistas:** mira los parámetros `dtype`, `usecols` y `parse_dates` de `read_csv`, y el
método `memory_usage`. Recuerda `deep=True`.

---

### 2. Reducir la memoria al menos 70%

Sobre el DataFrame de `observations.csv`, reduce el consumo **al menos un 70%** respecto a
la carga ingenua de la actividad 1.

Para cada conversión que hagas, documenta en una tabla:

| Columna | dtype antes | dtype después | MB antes | MB después | Qué se pierde |
|---|---|---|---|---|---|

La última columna es la importante. Ninguna conversión es gratis: `float32` pierde
precisión, `category` estorba si vas a hacer operaciones de texto, `int32` se desborda si
los valores crecen. Si en alguna fila escribes «nada», piénsalo otra vez.

**Criterio de éxito:** ≥70% de reducción **y** una justificación por columna.

---

### 3. Auditar la calidad de los datos

Antes de confiar en el dataset, interrógalo. Como mínimo:

- Porcentaje de valores faltantes por columna, en los tres archivos
- Duplicados: ¿hay identificadores de paciente repetidos en `patients.csv`?
- Coherencia temporal: ¿algún encuentro anterior a la fecha de nacimiento del paciente?
  ¿alguno posterior a la fecha de defunción?
- En `observations.csv`: ¿qué proporción de `VALUE` **no** se puede convertir a número?
  ¿Qué hay en esas filas?

**Entrega:** una sección de tu notebook con los hallazgos redactados, no sólo
tablas. Un problema encontrado y no explicado no cuenta.

---

### 4. Unir las tres tablas validando cardinalidades

Une `observations` → `encounters` → `patients`.

Antes de cada `merge`, **escribe en una celda de markdown qué cardinalidad esperas**
(¿uno a uno? ¿muchos a uno?) y cuántas filas debería tener el resultado. Después
compruébalo.

**Obligatorio:** usa el parámetro `validate=` en cada `merge`, y `indicator=True` para
auditar qué se unió y qué no. Reporta los conteos antes y después.

> Si alguna unión multiplica filas sin que lo esperaras, **no la arregles en silencio**:
> explica por qué pasó. Ese es el bug más caro del curso y el punto de esta actividad.

---

### 5. Responder preguntas clínicas

Con el dataset unido, calcula:

- Pacientes por grupo etnico y sexo (define tú los grupos y justifícalos)
- Número medio y mediano de encuentros por paciente
- Los 10 códigos de observación más frecuentes, con su descripción legible
- Para un analisis de laboratorio que elijas (por ejemplo HbA1c o presión sistólica): distribución de
  valores y cuántos pacientes tienen al menos tres mediciones

**Cuidado con la media de medias.** Si cada paciente tiene distinto número de mediciones,
promediar promedios no da la media global. Decide cuál de las dos responde tu pregunta y
di por qué.

---

### 6. Formato ancho y valores implausibles

Reestructura las observaciones a **formato ancho**: un renglón por paciente y fecha, una
columna por analito.

Después, detecta valores fuera de rango fisiológico. **No inventes los rangos:** busca
referencias y cítalas en el notebook. Reporta cuántos valores marcarías como implausibles
y qué harías con ellos.

**Pista:** `melt` y `pivot_table`. Piensa antes qué pasa si un paciente tiene dos
mediciones del mismo analito el mismo día — `pivot_table` no falla, agrega en silencio.

---

### 7. Procesar por lotes lo que no cabe

Fíjate un **presupuesto de memoria** artificial y bajo: por ejemplo, 200 MB.

Después procesa `observations.csv` **completo** sin superarlo nunca, calculando algo que
exija recorrer todas las filas (por ejemplo, la media y el conteo por código de observación).

**Entrega:** el pico de memoria medido, y una explicación de por qué tu enfoque no lo excede.

**Pistas:** el parámetro `chunksize` de `read_csv` devuelve un iterador. Para medir memoria
de verdad, mira `memory_profiler` o `tracemalloc` de la biblioteca estándar. Si generaste
20 000 pacientes y aun así todo cabe cómodamente, sube el volumen o baja el presupuesto
hasta que duela.

---

### 8. Los mismos resultados en Polars y en PySpark

Reimplementa **el pipeline de la actividad 5** (las preguntas clínicas) en Polars y en
PySpark, en local.

Completa esta tabla con datos medidos, no estimados:

| Herramienta | Líneas de código | Tiempo (s) | Memoria pico (MB) | Qué costó más |
|---|---|---|---|---|
| pandas | | | | |
| Polars | | | | |
| PySpark | | | | |

**Verifica que los tres den el mismo resultado.** Si no coinciden, averigua por qué antes
de seguir: casi siempre es un manejo distinto de nulos o de tipos, y descubrirlo vale más
que la tabla.

> PySpark en local no aprovecha nada de lo que hace bueno a Spark, y va a salir el más
> lento de los tres. Ése es justamente uno de los hallazgos del laboratorio.

---

### 9. La recomendación

Media cuartilla, en tu notebook:

> Para **este volumen concreto** de datos y **este tipo de análisis**, ¿qué herramienta
> usarías y por qué? ¿A partir de qué punto cambiarías de opinión?


---

## Entregable

En tu repositorio personal, dentro de `lab02/`:

- `analisis_pacientes.ipynb` — con narrativa en markdown **entre** las celdas de código.
  El notebook debe leerse como un documento, no como un volcado de celdas.
- `README.md` — cómo obtuviste los datos (comando de Synthea o URL de descarga), cuántos
  pacientes y cómo reproducir el análisis desde cero.
- La tabla comparativa de la actividad 8, también en el README.

---

## Criterios de evaluación

- [ ] Cero usos de `iterrows()` o `inplace=True`
- [ ] Cada decisión de limpieza y de dtype está justificada en texto
- [ ] La reducción de memoria alcanza ≥70% y cada conversión declara qué se pierde
- [ ] Todos los `merge` usan `validate=` y se reportan los conteos antes y después
- [ ] La actividad 7 respeta el presupuesto de memoria que te fijaste y lo demuestra con una medición
- [ ] La comparación de la actividad 8 reporta memoria y tiempo medidos, no estimados
- [ ] Los tres motores producen el mismo resultado, o se explica la diferencia
- [ ] La recomendación final se apoya en el volumen de datos, no en la moda
- [ ] El notebook corre completo de cero (Restart & Run All)

---

## Si te atoras

- **Synthea no genera nada:** revisa tu versión de Java (`java -version`). Necesita 11+.
- **Colab se queda sin RAM:** es un hallazgo, no un fracaso. Anota en qué punto pasó y con
  cuántas filas; eso es material para la actividad 9.
- **PySpark no arranca en Colab:** suele faltar `JAVA_HOME`. Búscalo antes de preguntar.
- **La reducción de memoria no llega al 70%:** estás dejando alguna columna en `object`.
  Revisa `select_dtypes`.

Depurar esto es parte del ejercicio. Inténtalo un rato antes de pedir ayuda.

## Estructura sugerida

```
s02-python-estructuras-pandas/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```
