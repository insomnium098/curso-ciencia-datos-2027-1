# Laboratorio 11 — Analítica longitudinal

**Sesión 11:** SQL Avanzado: CTEs, Window Functions y Subqueries
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Responder preguntas **temporales** sobre historias clínicas usando sólo SQL:
intervalos entre eventos, readmisiones, episodios de tratamiento y valores
basales.

Son las consultas que vas a necesitar para definir tu cohorte en la sesión 17
y para construir tus variables en la 23. Conviene que salgan bien ahora.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas duckdb jupysql` (o `psycopg` si elegiste Postgres)

**Punto de partida:** la base que montaste en el laboratorio 10, con tus datos
de Synthea. No hace falta nada nuevo.

Material complementario: [`recursos/s11-sql-avanzado.md`](../../recursos/s11-sql-avanzado.md)

---

## Actividades

### 1. De anidado a legible

Toma **dos** de las consultas más anidadas de tu laboratorio 10 y reescríbelas
con CTEs.

**Entrega:** las dos versiones lado a lado, y dos renglones sobre qué ganaste.
Si no ganaste nada, dilo — no todas las consultas mejoran con CTEs.

---

### 2. Depurar por partes

Toma tu CTE más larga y demuestra que se puede inspeccionar paso a paso:
ejecuta cada bloque por separado (`SELECT * FROM primera_cte`) y reporta
cuántas filas devuelve cada uno.

Esta es la ventaja práctica que no se ve en la diapositiva: **una consulta con
CTEs se depura; una anidada, no.**

---

### 3. Primera y última visita por paciente

Para cada paciente: fecha de la primera visita, de la última, y número total.

Resuélvelo **dos veces**: una con `GROUP BY` y otra con funciones de ventana
(`FIRST_VALUE` / `LAST_VALUE` o `ROW_NUMBER`).

**Entrega:** ambas consultas, la verificación de que dan lo mismo, y cuál
prefieres y por qué.

> Cuidado con `LAST_VALUE`: su frame por defecto no llega al final del grupo.
> Si te da un resultado raro, ya encontraste la trampa de la sesión.

---

### 4. Días entre visitas consecutivas

Con `LAG`, calcula los días transcurridos entre cada visita y la anterior,
por paciente.

Después:

- ¿Cuál es la mediana de días entre visitas?
- ¿Por qué la primera visita de cada paciente da `NULL`? ¿Está bien?
- ¿Qué harías con esos `NULL` al calcular la mediana?

---

### 5. Readmisión a 30 días

Detecta las readmisiones: un ingreso hospitalario que ocurre **dentro de los
30 días** posteriores al alta de un ingreso previo del mismo paciente.

**Entrega:** la consulta, el número de readmisiones y la tasa (readmisiones
entre altas elegibles).

Documenta tus decisiones: ¿cuentas todas las readmisiones o sólo la primera
por paciente? ¿el día 30 entra o no? **No hay una sola respuesta correcta,
pero tiene que estar declarada.**

---

### 6. Episodios de tratamiento (*gaps and islands*)

Elige un medicamento frecuente en tus datos y construye sus **episodios de
tratamiento continuo**, usando un gap de persistencia de 30 días.

**Entrega:** por paciente y episodio, la fecha de inicio, la de fin y la
duración. Más un histograma de duraciones.

Después repite con gaps de **60** y **90** días y compara: ¿cuántos episodios
salen con cada uno? Escribe dos renglones sobre qué implica elegir uno u otro.

> El gap de 30 días es una convención, no una ley. En la sesión 13 verás que
> es exactamente lo que hace la tabla `DRUG_ERA` de OMOP.

---

### 7. Deduplicar con `ROW_NUMBER`

En tus observaciones hay mediciones repetidas del mismo analito para el mismo
paciente. Quédate con **la más reciente de cada par (paciente, analito)**.

**Entrega:** la consulta con el patrón `ROW_NUMBER() … WHERE rn = 1`, y los
conteos antes y después.

Explica en un renglón por qué el filtro `rn = 1` **no puede** ir en el `WHERE`
de la misma consulta.

---

### 8. Media móvil y frames

Para un analito con varias mediciones por paciente, calcula:

1. El **acumulado** (frame por defecto)
2. La **media móvil de 3 mediciones** (frame declarado con `ROWS BETWEEN`)

**Entrega:** las dos columnas lado a lado para un paciente con al menos 5
mediciones, y la explicación de por qué difieren.

---

### 9. El valor más cercano a una fecha índice

Define una fecha índice para cada paciente (por ejemplo, su primer diagnóstico
de una condición) y obtén el valor de laboratorio **más cercano** a esa fecha,
dentro de una ventana de ±90 días.

**Decisión obligatoria:** ¿permites valores posteriores al índice? Justifícalo.
Si el desenlace que vas a estudiar ya ocurrió, tomar valores posteriores es
fuga de información (sesión 3, punto 7 del checklist).

---

### 10. Rendimiento: ventana contra self-join

Resuelve la actividad 4 (días entre visitas) **también** con un self-join,
sin funciones de ventana.

Compara con `EXPLAIN ANALYZE`: plan, tiempo y legibilidad.

**Entrega:** la tabla comparativa y tu conclusión.

---

## Entregable

`analitica_longitudinal.sql` con las consultas comentadas (cada una con la
pregunta clínica que responde), más un notebook con los histogramas, las
comparaciones de gaps y las mediciones de rendimiento.

---

## Criterios de evaluación

- [ ] Todas las consultas usan CTEs con nombres descriptivos
- [ ] Cada consulta lleva un comentario con su pregunta clínica
- [ ] La readmisión declara explícitamente sus criterios (ventana, qué cuenta)
- [ ] Los episodios se construyen correctamente y se comparan tres gaps
- [ ] El frame de cada función de ventana está **declarado**, no heredado por descuido
- [ ] Se explica por qué `rn = 1` va fuera de la CTE
- [ ] La actividad 9 declara y justifica la política sobre valores posteriores
- [ ] La comparación ventana/self-join incluye planes y tiempos reales

---

## Si te atoras

- **`LAST_VALUE` devuelve lo mismo que la fila actual:** frame por defecto.
  Necesitas `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`.
- **Mi promedio cambia en cada fila y no debería:** pusiste `ORDER BY` dentro
  de `OVER` sin declarar el frame. Estás viendo un acumulado.
- **«window functions are not allowed in WHERE»:** correcto, no se puede.
  Envuelve en una CTE y filtra fuera.
- **Los episodios salen todos de un día:** revisa que estés ordenando por
  fecha dentro de `LAG` y que las fechas sean tipo fecha, no texto.
- **La consulta recursiva no termina:** falta el corte de profundidad, o hay
  un ciclo en los datos.

## Estructura sugerida

```text
s11-sql-avanzado/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/
```
