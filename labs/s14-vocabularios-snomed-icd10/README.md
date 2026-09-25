# Laboratorio 14 — Construir y defender un concept set

**Sesión 14:** Vocabularios Estándar: SNOMED CT e ICD-10
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Definir **una** enfermedad con vocabularios estándar, medir cuánto cambia tu
cohorte según cómo la definas, y dejar por escrito por qué elegiste esa
definición y no otra.

El producto de hoy no es una consulta: es una **decisión documentada**. En la
sesión 17 vas a usar este concept set para construir una cohorte, y en el
proyecto final alguien te va a preguntar de dónde salió. Hoy escribes la
respuesta.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**. Montar el
entorno es parte de tu trabajo — aquí no hay nada que levantar.

**Necesitarás:** `pandas duckdb jupysql`

**Punto de partida:** tu base OMOP de los laboratorios 12 y 13, **con las tablas
de vocabulario cargadas** (`CONCEPT`, `CONCEPT_RELATIONSHIP`, `CONCEPT_ANCESTOR`).

> Si sólo cargaste un subconjunto del vocabulario, revísalo **ahora**: un
> `CONCEPT_ANCESTOR` incompleto produce concept sets que parecen correctos y no
> lo son. Si te faltan tablas, descárgalas de ATHENA antes de seguir.


---

## Actividades

### 1. Elige tu condición

Elige **una** condición relacionada con tu proyecto de tesis o con tu proyecto
final. No una área ("cáncer", "enfermedad cardiovascular"): una condición que
puedas definir en una frase y que un clínico reconocería.

**Entrega:** la condición, y dos o tres renglones sobre por qué te importa y qué
usarías la cohorte para responder.

> Si eliges algo demasiado raro, tu base sintética no tendrá pacientes y el
> resto del laboratorio se queda sin números. Antes de comprometerte, cuenta
> cuántas filas hay en `CONDITION_OCCURRENCE`. Si son menos de ~50 pacientes,
> elige otra cosa y di en tu entrega por qué cambiaste.

---

### 2. Encuentra el concepto semilla en ATHENA

Búscala en [ATHENA](https://athena.ohdsi.org/). Identifica el concepto SNOMED CT
**estándar** que mejor la representa.

**Entrega:** el `concept_id`, el `concept_name`, y una captura o transcripción de
sus cuatro banderas: `domain_id`, `vocabulary_id`, `concept_class_id`,
`standard_concept`.

Además, sube un nivel y baja un nivel en la jerarquía: ¿cuál es su padre
inmediato? ¿Cuántos descendientes tiene?

> **Trampa 1.** El primer resultado de la búsqueda casi nunca es el que quieres.
> Puede ser un concepto de ICD-10 (no estándar), un "finding" cuando querías un
> "disorder", o un concepto histórico marcado como inválido. Revisa las cuatro
> banderas antes de quedarte con uno.
>
> **Trampa 2.** Si el `domain_id` no es `Condition`, tus pacientes no están donde
> crees. Un concepto de dominio `Observation` no aparece en
> `CONDITION_OCCURRENCE` por más que suene a enfermedad.

---

### 3. Traduce ICD-10 a estándar

Escribe SQL que tome **al menos 10 códigos ICD-10** (o CIE-10) relacionados con
tu condición y los traduzca a conceptos estándar usando la relación `'Maps to'`.

Sácalos de donde quieras: la guía de codificación de tu hospital, un artículo
que uses de referencia, o la propia búsqueda en ATHENA.

**Entrega:** una tabla `codigo_icd10 → concept_id_origen → concept_id_estandar →
nombre_estandar`, y el conteo de cuántos de tus 10 mapearon a más de un concepto
estándar, y cuántos no mapearon a ninguno.

> **Trampa.** `'Maps to'` **no** es 1:1. Un código de ICD-10 puede mapear a dos o
> tres conceptos SNOMED. Si escribes un `JOIN` asumiendo que es 1:1, tus conteos
> de pacientes van a inflarse sin que lo notes, porque una fila se vuelve tres.
> Verifícalo contando antes y después del `JOIN`. Si los números no coinciden, ya
> sabes por qué.
>
> Recuerda también los cuatro filtros que vimos en clase: dirección correcta de
> la relación, `standard_concept`, vigencia del concepto, y vigencia de la
> relación. Omitir cualquiera de los cuatro te mete conceptos retirados.

---

### 4. Construye tres versiones del concept set

Usando `CONCEPT_ANCESTOR`, arma tres definiciones de la misma enfermedad:

| Versión | Contenido |
|---|---|
| **A — estricta** | sólo el concepto semilla |
| **B — amplia** | semilla + todos sus descendientes |
| **C — razonada** | semilla + descendientes − las exclusiones que tú decidas |

Cada versión debe quedar como una consulta SQL reproducible, no como una lista
de `concept_id` pegada a mano.

**Entrega:** las tres consultas y el número de conceptos que contiene cada una.

> Para la versión C todavía no decidas las exclusiones a ojo: llega a ellas en la
> actividad 6 y vuelve aquí.

---

### 5. Mide el impacto en pacientes

Cuenta los **pacientes distintos** que captura cada versión en tu
`CONDITION_OCCURRENCE`.

**Entrega:** una tabla con las tres cifras, los porcentajes de diferencia entre
ellas, y una gráfica. Acompáñala de un párrafo: si publicaras un estimador de
prevalencia, ¿cuál de los tres números reportarías y por qué?

> **Trampa.** Pacientes distintos, no filas. Un paciente con la misma condición
> registrada en ocho consultas es un paciente, no ocho.

---

### 6. Revisión manual de 20 conceptos

De los conceptos que entraron por "descendientes" en la versión B, toma **20** y
revísalos uno por uno. Para cada uno decide: ¿pertenece a la enfermedad que
definiste en la actividad 1, sí o no?

Si tienes más de 20, tómalos al azar con una semilla fija y dila en tu entrega —
tomar "los primeros 20" ordenados por `concept_id` no es una muestra.

**Entrega:** la tabla de 20 con tu veredicto, el conteo de falsos positivos, y la
lista de exclusiones que se va a la versión C.

> Aquí es donde suelen aparecer las sorpresas: formas gestacionales, neonatales,
> secundarias a otra causa, "en remisión", "antecedente familiar de", o la
> condición en un órgano que no te interesa. Ninguna es un error del vocabulario:
> son descendientes legítimos de un concepto que definiste más amplio de lo que
> querías.

---

### 7. Documenta la decisión

Escribe `justificacion_concept_set.md` con una tabla de este tipo:

| concept_id | nombre | incluido | por qué |
|---|---|---|---|

Una fila por cada concepto que **excluiste** y por cada inclusión que no sea
obvia. La justificación se escribe en términos clínicos o de la pregunta de
investigación, no en términos de SQL: "los casos gestacionales son una entidad
distinta y no queremos que entren a una cohorte de diabetes tipo 2" sirve;
"lo quité porque salía mucho" no.

Cierra con un párrafo sobre **sensibilidad y valor predictivo positivo**: ¿tu
definición final tiende a perder casos o a meter casos que no son? ¿Cuál de los
dos errores hace más daño a la pregunta que quieres responder?

---

## Entregable

1. `concept_set.sql` — las tres versiones, ejecutables de principio a fin
2. `justificacion_concept_set.md` — tabla de decisiones + párrafo de
   sensibilidad/VPP
3. La gráfica de impacto en pacientes

Todo versionado en tu repositorio.

---

## Criterios de evaluación

- [ ] El concepto semilla es estándar, del dominio correcto y está vigente
- [ ] La traducción de ICD-10 usa `'Maps to'` con los cuatro filtros y reporta los casos 1:N
- [ ] Las tres versiones del concept set son reproducibles desde SQL, no listas pegadas a mano
- [ ] Se reporta el impacto numérico de cada decisión en pacientes distintos
- [ ] Cada exclusión tiene una justificación clínica escrita
- [ ] La discusión de sensibilidad vs VPP está conectada con la pregunta de investigación
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Compara tu concept set con una definición publicada en la
  [OHDSI Phenotype Library](https://github.com/OHDSI/PhenotypeLibrary) para la
  misma condición. ¿Qué incluyeron que tú no? ¿Qué excluyeron?
- Repite la actividad 5 sobre `CONDITION_ERA` en vez de `CONDITION_OCCURRENCE` y
  explica por qué cambian (o no) los números.

---

## Estructura sugerida

```
s14-vocabularios-snomed-icd10/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab14: <descripción breve>` y solicita revisión.
