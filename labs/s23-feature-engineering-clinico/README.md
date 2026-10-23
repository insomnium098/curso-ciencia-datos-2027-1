# Laboratorio 23 — Construir la matriz de features del proyecto

**Sesión 23:** Feature Engineering con Datos Clínicos
**Bloque:** V — Machine Learning clínico

## Objetivo

Generar el dataset de modelado de tu proyecto: **documentado, sin fuga y
clínicamente defendible**.

El laboratorio 22 te pidió unas cuantas variables para que el flujo corriera.
Éste te pide el dataset de verdad — el que vas a usar en las sesiones 24 a 26 y
en tu tesis.

---

## Antes de empezar

**Necesitarás:** `pandas scikit-learn duckdb pytest matplotlib`

**Punto de partida:** tu cohorte de la sesión 17 y la base OMOP de los
laboratorios 12–16.

> **La regla de la sesión, aplicada a cada renglón de tu diccionario:**
> ¿esta variable existiría, con este valor, el día que yo quiero usar el modelo?

Material complementario: [`recursos/s23-feature-engineering-clinico.md`](../../recursos/s23-feature-engineering-clinico.md)

---

## Parte A — La línea de tiempo

### 1. Dibújala

Antes de una sola línea de SQL, dibuja la anatomía temporal **de tu problema**,
con días concretos:

```text
ventana de observación  │ blanqueo │ índice │ ventana de predicción
```

**Entrega:** la figura (a mano, en matplotlib o en Mermaid) y un párrafo
justificando **cada uno de los cuatro números**.

> El **blanqueo** es el que nadie justifica. Si tu desenlace es agudo, los días
> pegados al índice ya están contaminados por el evento que se está gestando.
> Decide cuántos días excluyes, y por qué.

---

## Parte B — Las variables

### 2. Al menos 25 variables desde OMOP

Escribe `build_features.sql` que genere, respetando la ventana de observación:

| Fuente | Mínimo |
|---|---|
| `PERSON` | edad al índice, sexo, observación previa |
| `CONDITION_OCCURRENCE` | 5 comorbilidades |
| `DRUG_EXPOSURE` | exposición reciente + número de ingredientes distintos |
| `MEASUREMENT` | 3 analitos × (último, tendencia, nº de mediciones) |
| `VISIT_OCCURRENCE` | visitas, hospitalizaciones, urgencias |

**Entrega:** el SQL y la matriz resultante, con sus dimensiones.

> **Trampa.** «Número total de visitas del paciente» incluye el futuro. Tiene que
> ser «número de visitas en `[-365, -blanqueo]`». Revisa que **toda** agregación
> tenga su ventana.

---

### 3. Tendencia y variabilidad, con cuidado

Para al menos un analito, calcula la **pendiente** y la **desviación estándar**
de sus mediciones en la ventana.

**Entrega:** las dos variables, y la decisión documentada de qué haces con los
pacientes que tienen **menos de tres mediciones**.

> **Trampa.** Una «tendencia» calculada con dos puntos es ruido con nombre
> elegante. Define un mínimo de observaciones y declara qué valor toma quien no
> lo alcanza (¿nulo? ¿cero? ¿una categoría aparte?).

---

### 4. Infiere comorbilidades desde los fármacos

Para **al menos tres** comorbilidades que creas relevantes, construye una
variable derivada de `DRUG_EXPOSURE` en lugar de `CONDITION_OCCURRENCE`.

**Entrega:** para cada una:

| | |
|---|---|
| ingredientes usados | el concept set (sesión 15), por ingrediente |
| regla | ¿cuántas recetas? ¿en qué ventana? |
| cuántos pacientes capta | contra cuántos tenían el diagnóstico codificado |
| nombre de la variable | `*_inferida`, no el nombre del diagnóstico |

> **Trampa.** Un fármaco rara vez es específico de una enfermedad: un
> betabloqueador puede ser insuficiencia cardiaca, hipertensión, arritmia o
> temblor esencial. Exige **persistencia** (≥2 recetas separadas) y, si puedes,
> **combina señales** (metformina + HbA1c alta).
>
> Y compara: ¿cuántos pacientes tenían el diagnóstico codificado y cuántos lo
> tienen por fármaco? Esa diferencia **es** un hallazgo sobre tu base, y va en
> la entrega.

---

### 5. Un índice clínico validado

Calcula **Charlson** (con los algoritmos de Quan et al., 2005) o **eGFR**
(CKD-EPI 2021) desde los datos crudos.

**Entrega:** el código, la distribución del índice en tu cohorte, y la referencia
exacta de la fórmula que usaste.

> Si usas eGFR, usa la ecuación de **2021** (sin coeficiente racial). Si usas una
> versión anterior en 2027, un revisor te lo va a marcar.

---

### 6. Agrupa por jerarquía, no por código

Toma tus diagnósticos y agrúpalos usando `CONCEPT_ANCESTOR` (sesión 16) en vez
de usar un `concept_id` por columna.

**Entrega:** cuántos conceptos distintos había, a cuántas categorías los
redujiste, y el criterio de agrupamiento.

> Aquí se cobra la sesión 16. Si terminas con 40 000 columnas casi todas en cero,
> no agrupaste.

---

## Parte C — Los faltantes

### 7. ¿Falta al azar?

Para cada variable con faltantes, compara la **tasa del desenlace** entre quienes
la tienen y quienes no.

**Entrega:** la tabla comparativa y una clasificación razonada por variable:
¿MCAR, MAR o MNAR? Con su argumento clínico.

> No basta con decir «es MNAR porque en salud siempre lo es». Enseña el número.

---

### 8. Indicadores de ausencia

Para las variables donde la ausencia carga señal, agrega una columna binaria
`<variable>_ausente` junto al valor imputado.

**Entrega:** las columnas nuevas y el porcentaje de faltantes de cada una.

---

### 9. Tres estrategias, medidas

Compara el efecto sobre el modelo base de la sesión 22:

| Estrategia | |
|---|---|
| A | sólo imputar la media / mediana |
| B | imputar + indicador de ausencia |
| C | imputación iterativa (`IterativeImputer`) |

**Entrega:** AUROC y AUPRC de las tres, con validación cruzada, y un veredicto.

> **Trampa.** Las tres van **dentro** del `Pipeline`. Imputar antes de partir es
> la fuga de la sesión 22, y aquí es especialmente fácil cometerla.
>
> Si las tres dan lo mismo, ése **es** el resultado. Repórtalo.

---

## Parte D — Documentar y probar

### 10. El diccionario de datos

Escribe `features.md` con una fila por variable:

```text
| variable | definición | ventana | unidades | % faltante | fuente | por qué |
```

**Entrega:** el diccionario completo, sin excepciones. Si tienes 28 variables,
tiene 28 filas.

---

### 11. Pruebas de calidad con pytest

Escribe pruebas que fallen si alguien rompe el dataset:

- **ninguna fecha usada es posterior al índice** (la prueba más importante)
- los valores están en rango fisiológico (una creatinina de 400 es un error)
- la edad al índice es consistente con la fecha de nacimiento
- el número de filas coincide con el tamaño de la cohorte
- no hay columnas 100 % constantes ni 100 % faltantes

**Entrega:** la suite, pasando.

> Estas pruebas son tu red de seguridad para el resto del semestre. Cuando en la
> sesión 24 cambies algo y el AUC se dispare, van a ser lo que te diga si fue
> mejora o fue fuga.

---

## Entregable

1. `build_features.sql` — la construcción, comentada
2. `features.md` — el diccionario completo
3. `faltantes.md` — el análisis de mecanismo y la comparación de las tres estrategias
4. `tests/` — la suite de pytest, pasando
5. La figura de la anatomía temporal

---

## Criterios de evaluación

- [ ] La línea de tiempo está dibujada y **los cuatro números justificados**
- [ ] Hay ≥25 variables, cada una con su ventana explícita
- [ ] **Ninguna** variable usa información posterior al índice — y hay una prueba que lo verifica
- [ ] Hay al menos tres comorbilidades inferidas desde fármacos, nombradas `*_inferida`
- [ ] Se compara cuántos pacientes capta el fármaco frente al diagnóstico codificado
- [ ] Se calculó un índice clínico validado, con su referencia exacta
- [ ] Los diagnósticos se agruparon por jerarquía, no por código individual
- [ ] El análisis de faltantes muestra **números**, no sólo la clasificación
- [ ] Las tres estrategias de imputación se compararon **dentro** del Pipeline
- [ ] El diccionario tiene una fila por variable, sin excepciones
- [ ] La suite de pytest pasa y cubre los cinco tipos de prueba
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Revisa qué covariables genera **FeatureExtraction** de OHDSI para tu cohorte y
  compara su lista con la tuya. ¿Qué se te ocurrió a ti que no está? ¿Qué está
  que no se te ocurrió?
- Calcula el **Elixhauser** además del Charlson y mira si aportan lo mismo.
- Prueba **imputación múltiple** (varias imputaciones, no una) y compara con la
  simple. Es lo que muchas revistas de epidemiología piden.

---

## Estructura sugerida

```
s23-feature-engineering-clinico/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab23: <descripción breve>` y solicita revisión.
