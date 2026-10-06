# Laboratorio 16 — Jerarquías en acción

**Sesión 16:** Navegación Jerárquica: `concept_relationship` y `concept_ancestor`
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Dejar de usar `CONCEPT_ANCESTOR` como caja negra. Al terminar vas a poder
explicar, con una consulta y no con una corazonada, **por qué** tu concept set
contiene lo que contiene y **por qué** un paciente concreto entró a tu cohorte.

Y de paso: hacer que tus consultas de vocabulario dejen de tardar minutos.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas duckdb jupysql`

**Punto de partida:** tu base OMOP de los laboratorios 12–15, con
`CONCEPT`, `CONCEPT_RELATIONSHIP`, `CONCEPT_ANCESTOR` y `RELATIONSHIP`.

> Sí, `RELATIONSHIP` también: es una tabla chica que casi nadie carga y hoy la
> vas a necesitar. Si no la tienes, bájala de ATHENA antes de empezar.

**Sobre `EXPLAIN ANALYZE`:** DuckDB y PostgreSQL lo soportan, con salidas
distintas. Usa el que tengas y di cuál en tu entrega; lo que se compara son tus
propios tiempos entre sí, no contra los de nadie más.

Material complementario: [`recursos/s16-jerarquias-concept-ancestor.md`](../../recursos/s16-jerarquias-concept-ancestor.md)

---

## Parte A — Las dos representaciones

### 1. Subir a la raíz con `WITH RECURSIVE`

Elige un concepto estándar de condición razonablemente específico (el de tu
sesión 14 sirve). Escribe un `WITH RECURSIVE` que recorra `'Is a'` **hacia
arriba** hasta llegar a la raíz de su jerarquía, devolviendo el nivel de cada
paso.

**Entrega:** la consulta, el camino completo hasta la raíz, y la profundidad.

> **Trampa 1.** `'Is a'` y `'Subsumes'` son la misma arista en sentidos
> opuestos. Si no filtras por `relationship_id`, recorres el grafo en ambas
> direcciones y la consulta **no termina**.
>
> **Trampa 2.** Pon un freno de profundidad (`WHERE nivel < 20`) desde la
> primera versión, no después de que se cuelgue.
>
> **Trampa 3.** Filtra `invalid_reason IS NULL` en las relaciones, o vas a
> recorrer aristas retiradas.

---

### 2. El mismo problema con `CONCEPT_ANCESTOR`

Resuelve lo mismo —todos los ancestros de ese concepto— con una sola consulta
sobre `CONCEPT_ANCESTOR`.

**Entrega:** la consulta, y la comparación de **conjuntos** con el resultado de
la actividad 1: ¿son idénticos?

> Si no coinciden, no lo dejes pasar: es el hallazgo más instructivo del
> laboratorio. Busca la explicación en la actividad 3.

---

### 3. La tabla que explica las diferencias

Consulta `RELATIONSHIP` y responde:

- ¿cuántos tipos de relación existen en tu vocabulario?
- ¿cuántos tienen `is_hierarchical = 1`?
- ¿cuántos tienen `defines_ancestry = 1`?
- ¿coinciden ambos conjuntos?

Después, lista **todas las relaciones distintas que salen** de un concepto de
fármaco de tu sesión 15, y explica con tus palabras **cinco** de ellas.

**Entrega:** los conteos, la lista de relaciones, las cinco explicaciones, y una
frase conectando esto con cualquier diferencia que hayas visto en la actividad 2.

---

## Parte B — Poli-jerarquía

### 4. Encontrar un caso real en tu base

`CONCEPT_ANCESTOR` te da la pista gratis: busca pares donde
`min_levels_of_separation ≠ max_levels_of_separation`. Eso significa que hay
**más de un camino** entre ese ancestro y ese descendiente.

Elige uno, y reconstruye **los dos caminos** con `CONCEPT_RELATIONSHIP`.

**Entrega:** el par de conceptos, los dos caminos completos, y una frase
clínica: ¿por qué tiene sentido que pertenezca a las dos ramas?

---

### 5. Medir el daño

Construye un concept set de **insuficiencia cardiaca** (o de la condición que
elegiste) que incluya deliberadamente dos ramas que se traslapen. Después cuenta
de tres formas:

| | Qué cuentas |
|---|---|
| A | `COUNT(*)` sobre el `JOIN` con `CONCEPT_ANCESTOR` |
| B | `COUNT(DISTINCT concept_id)` |
| C | `COUNT(DISTINCT person_id)` |

**Entrega:** los tres números y una explicación de por qué difieren. Sólo uno de
los tres responde «¿cuántos pacientes tienen esta condición?».

> **Trampa.** Es tentador reportar A porque es el más grande. Es también el
> único de los tres que no significa nada.

---

## Parte C — Depurar

### 6. «¿Por qué entró este paciente?»

Escribe **una consulta parametrizable por `person_id`** que, dado un paciente de
tu cohorte, devuelva el camino completo:

```text
person_id → evento → source_concept_id → concepto estándar
          → ancestro de tu concept set → por qué rama
```

**Entrega:** la consulta y su salida para **tres** pacientes distintos, uno de
ellos elegido por otra persona del grupo.

> Este es el entregable más reutilizable del semestre. Guárdalo bien: alguien te
> va a pedir exactamente esto en la defensa de tu tesis.

---

### 7. Cazar conceptos muertos

Revisa tu concept set contra `CONCEPT.invalid_reason` y reporta:

- cuántos conceptos están retirados (`'D'` o `'U'`)
- para los `'U'`, cuál es su reemplazo según `'Concept replaced by'`
- cuántos pacientes ganas o pierdes al actualizarlos

**Entrega:** la tabla de conceptos retirados con su reemplazo, y el efecto
numérico de la corrección.

> Esto falla en silencio: la consulta corre, devuelve menos pacientes y nadie se
> entera. Por eso se audita a propósito.

---

## Parte D — Rendimiento

### 8. Antes y después

Mide con `EXPLAIN ANALYZE` la misma pregunta escrita de dos formas:

1. `WHERE condition_concept_id IN (subconsulta sobre CONCEPT_ANCESTOR)`
2. concept set **materializado** en una tabla, con índice, y `JOIN`

**Entrega:** una tabla con los tiempos de las dos versiones, el plan de ejecución
de cada una, y una frase señalando **qué cambió en el plan** — no sólo que el
número bajó.

> Corre cada versión tres veces y reporta la mediana: la primera ejecución
> incluye lecturas de disco que no vuelven a ocurrir.
>
> Puede pasar que en tu base, que es chica, la diferencia sea despreciable.
> **Repórtalo así.** «No medí diferencia a esta escala» es un resultado honesto;
> inventar una mejora no lo es.

---

## Entregable

`jerarquias.sql` con las **ocho** consultas, cada una precedida de un comentario
que diga qué responde y qué encontraste, más:

- `tiempos.md` — la tabla de la actividad 8 con los planes de ejecución
- `hallazgos.md` — el caso de poli-jerarquía, los conceptos retirados y su efecto

---

## Criterios de evaluación

- [ ] La versión recursiva y la de ancestros devuelven el **mismo conjunto**, o se explica por qué no
- [ ] La recursiva tiene freno de profundidad y filtra por `relationship_id`
- [ ] Se documenta al menos un caso **real** de poli-jerarquía encontrado en la base propia
- [ ] Se explica por qué `COUNT(*)`, `COUNT(DISTINCT concept_id)` y `COUNT(DISTINCT person_id)` difieren
- [ ] La consulta de depuración funciona para **cualquier** paciente, no sólo para el del ejemplo
- [ ] Los tiempos se reportan como mediana de tres corridas, con el plan de ejecución
- [ ] Si no hubo mejora medible, se dice — no se inventa
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Ejecuta [CohortDiagnostics](https://ohdsi.github.io/CohortDiagnostics/) sobre tu
  concept set y compara sus **conceptos huérfanos** con lo que tú encontraste a mano.
- Escribe la recursiva hacia **abajo** (descendientes) y compárala con
  `CONCEPT_ANCESTOR` en una jerarquía profunda, como la de fármacos. Ahí la
  diferencia de tiempo sí se nota.

---

## Estructura sugerida

```
s16-jerarquias-concept-ancestor/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab16: <descripción breve>` y solicita revisión.
