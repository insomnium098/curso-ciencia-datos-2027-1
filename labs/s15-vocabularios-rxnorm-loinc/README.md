# Laboratorio 15 — Concept sets de medicamentos y laboratorios

**Sesión 15:** Vocabularios Estándar: RxNorm y LOINC
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Construir dos concept sets que puedas reutilizar el resto del semestre: uno de
**exposición a fármacos** y uno de **analitos de laboratorio**. Y hacer lo que
casi nadie hace: **mapear a mano un catálogo local** y reportar honestamente lo
que no se pudo mapear.

En la sesión 14 aprendiste que definir una enfermedad es una decisión. Hoy vas a
descubrir que con fármacos y laboratorios hay **más** decisiones, no menos.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas duckdb jupysql matplotlib`

**Punto de partida:** tu base OMOP de los laboratorios 12–14, con vocabularios
cargados. Para este laboratorio necesitas además que estén las tablas de
`RxNorm`, `RxNorm Extension`, `ATC`, `LOINC` y `UCUM` en `CONCEPT`.

> Verifícalo antes de empezar: cuenta filas de `CONCEPT` agrupando por
> `vocabulary_id`. Si falta alguno, descárgalo de ATHENA ahora. Descubrirlo en
> la actividad 4 es perder media hora.

---

## Parte A — Fármacos

### 1. Reconocer el terreno

Explora [RxNav](https://mor.nlm.nih.gov/RxNav/) y localiza el **RxCUI del
ingrediente** de tres medicamentos relevantes para tu proyecto.

Para cada uno anota: el RxCUI, el TTY, cuántas formas clínicas (SCDF) tiene y
cuántos nombres de marca (BN).

**Entrega:** la tabla de tres filas y la fecha de consulta.

> **Trampa.** Buscar «metformina» te devuelve decenas de resultados y la mayoría
> **no** son el ingrediente: son productos, marcas y combinaciones. Filtra por
> `TTY = IN`. Si tu fármaco sólo aparece como PIN (ingrediente preciso, con
> sal), sube un nivel: para farmacoepidemiología te interesa el IN.

---

### 2. Del producto al ingrediente

En tu base OMOP, toma los 20 `drug_concept_id` más frecuentes de
`DRUG_EXPOSURE` y resuelve, para cada uno, **cuál es su ingrediente**.

**Entrega:** la tabla `drug_concept_id → nombre → concept_class_id →
ingrediente(s)`, y el conteo de cuántos de los 20 tienen **más de un**
ingrediente.

> **Trampa 1.** `CONCEPT_ANCESTOR` incluye a cada concepto **como ancestro de sí
> mismo** (`min_levels_of_separation = 0`). Según cómo filtres, vas a contar de
> más o de menos. Decide y documenta cuál usaste.
>
> **Trampa 2.** Un producto combinado tiene varios ingredientes, así que el
> `JOIN` multiplica filas. Cuenta antes y después.

---

### 3. De la clase ATC a los ingredientes

Parte de la clase **`A10B`** (hipoglucemiantes orales, excluyendo insulinas) y
obtén **todos los ingredientes** que cuelgan de ella en tu vocabulario.

Después, baja un nivel más: obtén **todos los `drug_concept_id` de tu base** que
correspondan a esos ingredientes.

**Entrega:** número de ingredientes, número de productos, y número de pacientes
distintos expuestos a cualquiera de ellos.

> **Trampa.** ATC no cubre todo. Habrá productos en tu base sin ningún ancestro
> ATC, y desaparecen de la selección sin avisar. **Cuéntalos** y repórtalos: ése
> número es parte del resultado, no un detalle.

---

### 4. «Exposición a metformina», tres veces

Igual que en la sesión 14, construye tres definiciones y mide cada una:

| Versión | Qué incluye |
|---|---|
| **A** | sólo productos de **un ingrediente** (monoterapia) |
| **B** | todo lo que cuelga del ingrediente, **combinaciones incluidas** |
| **C** | B, pero excluyendo las presentaciones que tú decidas y justifiques |

**Entrega:** los tres conteos de pacientes distintos, una gráfica, y un párrafo:
si estudiaras el efecto de la metformina sobre la función renal, ¿cuál usarías?

> Si tu base sintética tiene poca metformina, elige otro ingrediente frecuente y
> dilo. El ejercicio es el mismo.

---

## Parte B — Laboratorio

### 5. Leer tres códigos LOINC

Para **4548-4**, **2160-0** y **2345-7**, descompón cada uno en sus seis ejes
(Component, Property, Time, System, Scale, Method) y escribe en una frase qué
mide exactamente.

**Entrega:** la tabla de tres filas por seis columnas, más la frase de cada uno.

> **Trampa.** El eje `System` es el que más confusión causa: *suero o plasma* no
> es *sangre total*, y son códigos distintos. Si tu base mezcla ambos para «el
> mismo» analito, eso es un hallazgo, no un error tuyo.

---

### 6. El concept set de un analito no es un código

Construye el concept set de **HbA1c** para tu base: todos los
`measurement_concept_id` que realmente representan una HbA1c, incluyendo las
variantes por método.

**Entrega:** la lista de códigos incluidos, cuántas mediciones aporta cada uno, y
la justificación de cualquiera que hayas dejado fuera.

> Compara el resultado con lo que habrías obtenido usando sólo `4548-4`. La
> diferencia es el punto del ejercicio.

---

### 7. Auditoría de unidades

Para los analitos de la actividad 5, cruza `measurement_concept_id` con
`unit_concept_id` y reporta:

- cuántas unidades distintas aparecen por analito
- qué porcentaje de mediciones tiene `unit_concept_id = 0` o nulo
- el histograma de `value_as_number` **separado por unidad**

**Entrega:** la tabla, los histogramas y una frase por analito: ¿se pueden
promediar tal cual, sí o no?

> **Trampa.** Si el histograma de creatinina es bimodal con una moda cerca de 1 y
> otra cerca de 90, no tienes dos poblaciones: tienes `mg/dL` y `µmol/L` en la
> misma columna. El factor es ≈ 88.4.

---

## Parte C — El mundo real

### 8. Mapear un catálogo local

Construye un catálogo local ficticio de **15 medicamentos** escritos como los
escribiría una farmacia hospitalaria mexicana: abreviados, en mayúsculas, con la
sal, con la presentación pegada al nombre. Inspírate en el
[Compendio Nacional de Insumos para la Salud](https://www.gob.mx/csg/articulos/compendio-nacional-de-insumos-para-la-salud-367182)
(el sucesor del Cuadro Básico, del Consejo de Salubridad General).

Incluye deliberadamente al menos: una abreviatura (`HCTZ`), una combinación, una
presentación que no exista en RxNorm, y algo que **no sea un fármaco** (una
solución, material de curación).

Mapéalos a conceptos estándar usando [Usagi](https://github.com/OHDSI/Usagi) o
búsqueda manual en ATHENA, y produce una tabla con estas columnas:

```text
| clave_local | descripcion_local | concept_id | concept_name | confianza | quién y por qué |
```

`confianza` con tres valores: **alta**, **dudosa**, **no mapeable**.

**Entrega:** la tabla completa de 15 filas, el porcentaje mapeado con confianza
alta, y un párrafo sobre qué fue lo más difícil.

> Lo **no mapeable** es un resultado legítimo y se reporta. Un mapeo falsamente
> confiado contamina todo lo que venga después; uno marcado como dudoso se puede
> usar con cuidado.

---

### 9. Empaquetar y versionar

Deja tus concept sets como archivos SQL ejecutables en una carpeta
`concept_sets/`, cada uno con un encabezado en comentarios que diga:

- qué define
- qué versión de vocabulario usaste y en qué fecha
- cuántos conceptos devuelve
- qué decisiones se tomaron y por qué

---

## Entregable

1. `concept_sets/` — los SQL de fármacos y de analitos, con encabezado
2. `mapeo_catalogo_local.csv` — las 15 filas con su columna de confianza
3. `auditoria_unidades.md` — tabla, histogramas y veredicto por analito
4. Un `README.md` corto que explique qué hay en cada archivo

Todo versionado en tu repositorio.

---

## Criterios de evaluación

- [ ] Los concept sets se construyen por **jerarquía**, no con listas de ids pegadas a mano
- [ ] Se reporta cuántos productos de la base quedan **fuera** de la selección por ATC
- [ ] La decisión sobre combinaciones (incluir o excluir) está explícita y justificada
- [ ] El concept set de HbA1c incluye variantes por método, no un solo código
- [ ] La auditoría de unidades reporta **números concretos**, no impresiones
- [ ] Cada mapeo dudoso está marcado como dudoso, con quién lo decidió y por qué
- [ ] Cada SQL trae versión de vocabulario y fecha
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Repite la actividad 3 con una clase ATC de tu área (`C09` para IECA/ARA-II,
  `J01` para antibacterianos) y compara qué tan bien cubierta está en tu base.
- Revisa la lista [Top 2000 de LOINC](https://loinc.org/usage/obs/) y calcula qué
  porcentaje de las mediciones de tu base cae dentro de ella.

---

## Estructura sugerida

```
s15-vocabularios-rxnorm-loinc/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab15: <descripción breve>` y solicita revisión.
