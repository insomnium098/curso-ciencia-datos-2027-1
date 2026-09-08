# Laboratorio 10 — Tu propia base clínica, y 15 preguntas

**Sesión 10:** SQL Fundamentals: Queries, Joins y Agregaciones
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Montar **tu propia base de datos clínica** desde cero y responder preguntas
reales con SQL.

Esta base te acompaña **hasta la sesión 18** y es la materia prima de tu
proyecto final. Vale la pena montarla bien hoy.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas duckdb jupysql` (o `psycopg` si eliges Postgres)

Material complementario: [`recursos/s10-sql-fundamentals.md`](../../recursos/s10-sql-fundamentals.md)

> Si ya generaste datos de Synthea en el laboratorio 2, **reutilízalos**.
> Si no, la actividad 1 lo resuelve.

---

## Actividades

### 1. Generar los datos

Con [Synthea](https://synthetichealth.github.io/synthea/), genera **al menos
5 000 pacientes** exportados a CSV. Anota el comando exacto que usaste: forma
parte de la reproducibilidad.

Los archivos que vas a cargar: `patients`, `encounters`, `conditions`,
`medications`, `observations`.

---

### 2. Elegir motor y justificarlo

Decide entre **DuckDB** y **PostgreSQL**, y escribe tres renglones
justificándolo: ¿dónde vas a trabajar? ¿necesitas que otros se conecten?
¿te importa parecerte a lo que usa OHDSI?

No hay respuesta correcta. Se evalúa el criterio.

---

### 3. Cargar de forma reproducible

Escribe un **script** (no celdas sueltas) que cree las tablas y cargue los CSV.
Debe poder correrse dos veces sin romperse.

Declara tipos explícitos: las fechas como fecha, no como texto. Vas a hacer
aritmética con ellas toda la sesión.

**Entrega:** el script y el conteo de filas por tabla.

---

### 4. Explorar el esquema

Antes de consultar, entiende qué tienes:

- Lista de tablas, columnas y tipos
- Conteo de filas por tabla
- ¿Cuál es la llave primaria de cada una? ¿Cuáles son las foráneas?
- **Dibuja el diagrama entidad-relación** (a mano, dbdiagram o Mermaid)

**Entrega:** el diagrama. Te va a servir en todas las sesiones siguientes.

---

### 5. Auditar antes de confiar

Responde con SQL:

- ¿Hay `patient_id` duplicados en `patients`?
- ¿Hay encuentros cuya fecha sea anterior al nacimiento del paciente?
- ¿Qué porcentaje de `observations` tiene el valor nulo?
- ¿Cuántos encuentros apuntan a un paciente que **no existe** en `patients`?

**Pista:** las dos últimas se responden con un anti-join. La figura de la
sesión te dice cuál.

---

### 6. Quince preguntas, dificultad creciente

Responde con SQL y **comenta cada consulta con la pregunta clínica** que
responde. Cinco de cada nivel:

**Básicas** — conteos y filtros simples:
1. ¿Cuántos pacientes hay? ¿Cuántos siguen vivos?
2. Distribución por sexo
3. Los 10 diagnósticos más frecuentes
4. Pacientes nacidos antes de 1960
5. Encuentros por año

**Intermedias** — agregación y agrupación:
6. Número medio y mediano de encuentros por paciente
7. Edad media al primer diagnóstico de una condición que elijas
8. Diagnósticos con **más de 50 pacientes distintos**
9. Distribución de un analito (media, mediana, p10, p90)
10. Pacientes por grupo etario y sexo

**Avanzadas** — joins y anti-joins:
11. Pacientes con diabetes **y** hipertensión
12. Pacientes con diabetes **sin** ninguna medición de HbA1c
13. Para cada paciente: su primer y su último encuentro
14. Medicamento más frecuente entre los pacientes de una condición
15. Pacientes que tuvieron un encuentro de urgencias **sin** diagnóstico registrado

---

### 7. El join que multiplica

Provoca el error a propósito: haz un join que duplique filas (por ejemplo,
uniendo encuentros con condiciones sin agregar).

**Demuestra el daño:** compara `count(*)` antes y después, y muestra cómo un
promedio calculado sobre el resultado inflado da un número **distinto y
plausible**.

Después corrígelo. **Entrega:** los tres números (correcto, inflado, corregido)
y la explicación.

---

### 8. La trampa del `LEFT JOIN`

Escribe una consulta con `LEFT JOIN` donde el filtro de la tabla derecha esté
**en el `WHERE`**. Cuenta las filas. Muévelo al `ON`. Cuenta otra vez.

Explica por qué cambió el resultado.

---

### 9. Medir el rendimiento

Elige una consulta lenta de las 15 anteriores y:

1. Córrela con `EXPLAIN ANALYZE` y guarda el plan y el tiempo
2. Cambia algo: crea un índice (Postgres) o reordena filtros y reduce columnas
   (DuckDB)
3. Vuelve a medir

**Entrega:** los dos planes, los dos tiempos y tu explicación de qué cambió.

> Si estás en DuckDB, es probable que el índice apenas ayude. **Eso también
> es un hallazgo:** explica por qué, con lo que dice la diapositiva sobre
> motores columnares.

---

### 10. SQL contra pandas

Reproduce **tres** de tus 15 consultas en pandas. Compara: líneas de código,
legibilidad y tiempo.

Escribe dos renglones: para este volumen y estas preguntas, ¿qué usarías?
¿A partir de qué punto cambiarías de opinión?

---

## Entregable

En tu repositorio: `sql/carga.sql` (o el script de carga), `sql/consultas.sql`
con las 15 preguntas comentadas, el diagrama ER, y un notebook con la auditoría,
las mediciones de rendimiento y la comparación con pandas.

**No subas los CSV de Synthea.** Documenta el comando que los genera.

---

## Criterios de evaluación

- [ ] La carga es reproducible: otra persona la repite con tu script
- [ ] Las fechas están cargadas como fecha, no como texto
- [ ] El diagrama ER existe y es correcto
- [ ] Cada consulta lleva un comentario con la pregunta clínica
- [ ] Las 15 preguntas están respondidas y las 5 avanzadas usan joins correctos
- [ ] Al menos una consulta usa un anti-join
- [ ] El experimento del join que multiplica reporta los tres números
- [ ] El experimento del `LEFT JOIN` explica correctamente el cambio
- [ ] Las mediciones de rendimiento incluyen planes y tiempos reales
- [ ] Ninguna consulta usa `SELECT *` para el resultado final

---

## Si te atoras

- **La carga falla por tipos:** las fechas de Synthea vienen en formato ISO.
  Declara el tipo al crear la tabla o convierte al insertar.
- **`count(*)` te da más filas de las que esperabas:** join que multiplica.
  Actividad 7.
- **Un `WHERE` no devuelve lo que esperas:** ¿hay NULL en esa columna?
  Recuerda que `<> 'x'` excluye los nulos.
- **`GROUP BY` se queja de una columna:** todo lo del `SELECT` o se agrega o
  se agrupa. Vuelve al orden lógico.
- **La consulta tarda muchísimo:** ¿estás trayendo columnas que no usas?
  ¿Filtras lo antes posible?

## Estructura sugerida

```text
s10-sql-fundamentals/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/
```
