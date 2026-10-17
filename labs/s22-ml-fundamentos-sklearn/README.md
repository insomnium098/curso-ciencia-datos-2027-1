# Laboratorio 22 — Primer modelo predictivo clínico

**Sesión 22:** Machine Learning: Fundamentos, Flujo de Trabajo y scikit-learn
**Bloque:** V — Machine Learning clínico

## Objetivo

Construir un modelo de predicción sobre **tu propia cohorte** de la sesión 17:
sin fuga, bien validado, y comparado contra un baseline que tenga sentido.

Y hacer algo que casi nunca se enseña: **provocar una fuga a propósito**, medir
cuánto infla el AUC, y corregirla. Se aprende viéndolo en tus datos.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas scikit-learn matplotlib duckdb`

**Punto de partida:** tu cohorte de la sesión 17 (con `cohort_start_date`) y la
base OMOP de los laboratorios 12–16.

> **La regla de oro de este laboratorio:** cada variable que metas al modelo
> tiene que existir **en la fecha índice**. Si no existirías tú mismo seguro de
> poder calcularla ese día, no entra.

Material complementario: [`recursos/s22-ml-fundamentos-sklearn.md`](../../recursos/s22-ml-fundamentos-sklearn.md)

---

## Parte A — El dataset

### 1. Define el desenlace

Elige un desenlace binario que ocurra **después** de la fecha índice, en una
ventana que tú declares (por ejemplo, `[1, 365]`).

**Entrega:** la definición en prosa, la ventana con su justificación, y la
**prevalencia**: cuántos positivos hay, en número absoluto.

> Si tienes menos de ~50 eventos, dilo y sigue adelante con la advertencia. Es el
> conteo de factibilidad de la sesión 18 aplicado a ti.

---

### 2. Construye la matriz de features

Con SQL sobre tu base, construye una tabla: una fila por sujeto de la cohorte,
una columna por variable.

Incluye al menos: edad en la fecha índice, sexo, tres comorbilidades previas y
dos mediciones de laboratorio.

**Entrega:** la consulta y la tabla resultante.

> **Trampa.** Cada variable necesita su **ventana temporal explícita**. «Tiene
> diabetes» no es una variable; «≥1 diagnóstico de diabetes en `[-365, -1]`» sí
> lo es. Es exactamente la lección de la sesión 17.

---

### 3. Documenta cada variable

Escribe `features.md` con una fila por variable:

```text
| variable | definición | ventana | % faltante | por qué la incluyo |
```

**Entrega:** la tabla completa.

> Esto no es burocracia: es lo que te va a permitir responder, en tu examen,
> «¿esta variable estaba disponible en el momento de la predicción?».

---

## Parte B — Partir bien

### 4. La partición

Parte en entrenamiento y prueba respetando **dos** cosas a la vez:

- el **tiempo**: entrena con lo viejo, prueba con lo nuevo
- el **paciente**: nadie puede estar en los dos lados

**Entrega:** el código, el tamaño de cada conjunto, y la prevalencia del
desenlace en cada uno.

> **Trampa.** Si las prevalencias son muy distintas entre entrenamiento y prueba,
> no necesariamente está mal: puede que el desenlace cambie con el tiempo. Pero
> tienes que **notarlo y comentarlo**, no descubrirlo al final.

---

### 5. Guarda la prueba

A partir de aquí, el conjunto de prueba **no se toca**. Ni para explorar, ni para
«ver cómo va».

**Entrega:** una línea en tu notebook, explícita, diciendo dónde quedó guardado y
que no se vuelve a abrir hasta la actividad 9.

---

## Parte C — El modelo

### 6. Todo dentro del `Pipeline`

Arma un `Pipeline` con `ColumnTransformer` que haga imputación, escalado y
codificación **dentro**.

**Entrega:** el pipeline.

> **Trampa.** Si en algún punto de tu notebook aparece un `fit_transform` sobre
> `X` completo antes de partir, ya tienes fuga. Búscalo antes de seguir.

---

### 7. Tres modelos, en orden

| Modelo | Para qué |
|---|---|
| `DummyClassifier` | el piso. Si no le ganas, para y revisa el dataset |
| Regresión logística regularizada | el que tienes que superar de verdad |
| Bosque aleatorio | sólo cuenta si le gana a la anterior |

**Entrega:** AUROC **y AUPRC** de los tres, con validación cruzada: media y
desviación estándar entre pliegues.

> **Trampa.** Con un desenlace al 2 %, el `DummyClassifier` tiene 98 % de
> exactitud. Por eso la exactitud no se reporta en este laboratorio.

---

### 8. Valida con la estructura correcta

Usa `GroupKFold` (o `StratifiedGroupKFold`) por paciente.

**Entrega:** los resultados, y un párrafo justificando **por qué ese esquema** y
no `KFold` a secas. Si puedes, muestra la diferencia entre los dos: suele ser
grande y es la mejor evidencia.

---

### 9. Ahora sí, la prueba

Evalúa el mejor modelo en el conjunto de prueba. **Una vez.**

**Entrega:** las métricas, y una comparación honesta con lo que esperabas según
la validación cruzada.

> Si el resultado en prueba es **peor** que en validación, eso es normal y es
> información. Si es **mejor**, desconfía: suele indicar que la partición no
> respetó la estructura.

---

## Parte D — La fuga, a propósito

### 10. Provócala

Rompe el pipeline deliberadamente, de **una** de estas formas:

- escala con la media de todo el dataset antes de partir
- incluye una variable medida **después** de la fecha índice
- permite que el mismo paciente aparezca en los dos lados

**Entrega:** el AUC con fuga y el AUC sin fuga, lado a lado, y la explicación del
mecanismo: ¿de dónde salió exactamente la información que no debía estar?

**Después, corrígela** y verifica que las métricas vuelven a su lugar.

> Éste es el entregable que más vale del laboratorio. Lo que se aprende aquí es a
> reconocer la **sensación** de un resultado demasiado bueno.

---

## Entregable

1. `modelo_base.ipynb` — el flujo completo, en orden
2. `features.md` — la tabla de variables con sus ventanas
3. `fuga.md` — el experimento de la actividad 10, con los dos AUC y la explicación

---

## Criterios de evaluación

- [ ] Cada variable tiene su ventana temporal explícita y documentada
- [ ] **Todo** el preprocesamiento ocurre dentro del `Pipeline`
- [ ] La partición respeta tiempo **y** paciente
- [ ] El conjunto de prueba se evaluó **una sola vez**
- [ ] Se reportan AUROC **y** AUPRC (con su línea base: la prevalencia), no exactitud
- [ ] Se reportan precisión y recall por separado, no sólo el F1
- [ ] El esquema de validación está justificado por la estructura de los datos
- [ ] Se supera al `DummyClassifier`, y se discute si el modelo complejo justifica su costo
- [ ] El experimento de fuga está hecho, medido y explicado
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Lee el checklist de [TRIPOD+AI](https://pmc.ncbi.nlm.nih.gov/articles/PMC11025451/)
  y marca cuántos de sus 27 ítems podrías responder hoy con tu notebook. Los que
  no, son tu lista de pendientes para la tesis.
- Compara `class_weight="balanced"` contra no usarlo: mira qué pasa con el AUPRC
  **y** con la calibración. La sesión 25 explica por qué se rompe.
- Haz una validación **temporal estricta**: entrena sólo con los primeros dos años
  y prueba con el tercero. ¿Cuánto cae el rendimiento? Eso es lo que pasaría de
  verdad.

---

## Estructura sugerida

```
s22-ml-fundamentos-sklearn/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab22: <descripción breve>` y solicita revisión.
