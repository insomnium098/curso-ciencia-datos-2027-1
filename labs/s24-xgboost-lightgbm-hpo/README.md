# Laboratorio 24 — Comparar modelos y optimizar el de riesgo clínico

**Sesión 24:** Modelos Avanzados: Comparar Algoritmos e Hiperparámetros
**Bloque:** V — Machine Learning clínico

## Objetivo

Llevar el modelo de la sesión 23 a su **máximo desempeño honesto**, y entregar
la tabla que responde la única pregunta que importa: **¿la complejidad valió la
pena?**

«No valió la pena» es una conclusión perfectamente válida — y con cohortes
chicas, la más frecuente.

---

## Antes de empezar

**Necesitarás:** `scikit-learn xgboost lightgbm optuna mlflow pandas matplotlib`

**Punto de partida:** la matriz de features de la sesión 23, con su diccionario
y su suite de pruebas pasando.

> **Fija la semilla desde la primera celda.** Sin ella, nada de lo que midas hoy
> se puede reproducir mañana — ni por ti.

Material complementario: [`recursos/s24-xgboost-lightgbm-hpo.md`](../../recursos/s24-xgboost-lightgbm-hpo.md)

---

## Parte A — El catálogo, sobre los mismos datos

### 1. Entrena el catálogo, sin ajustar nada

Sobre tu matriz de la sesión 23, con el mismo `Pipeline` y la misma partición:

| Familia | Modelo |
|---|---|
| baseline | `DummyClassifier` |
| lineal | regresión logística regularizada |
| basado en distancia | k-NN |
| margen con kernel | SVM (RBF) |
| árboles | Random Forest |
| boosting | XGBoost **y** LightGBM |
| *(opcional)* no supervisado | `KMeans` sobre las mismas variables, para ver qué agrupa |

**Entrega:** AUROC y AUPRC de los siete, con validación cruzada (media y
desviación entre pliegues) y el tiempo de entrenamiento de cada uno.

> **Trampa.** k-NN y SVM **necesitan escalado**; los árboles no. Si tu
> `ColumnTransformer` no escala, estás saboteando a dos de los cinco. Ponlo en el
> pipeline de quien lo necesita, no «a todos por si acaso».

---

### 2. ¿Qué supone cada una sobre tus datos?

Para los tres mejores y el peor, escribe una frase: **por qué** crees que le fue
así, en términos de lo que ese modelo supone.

**Entrega:** cuatro párrafos cortos.

> Ejemplos del tipo de razonamiento que se espera: «la logística quedó cerca
> porque mis variables ya están construidas como riesgos monótonos»; «k-NN se
> hundió porque con 40 dimensiones casi nadie tiene vecinos cercanos»; «el SVM
> tardó tres minutos y no ganó nada».

---

### 3. LightGBM y la trampa de `num_leaves`

Entrena LightGBM con `num_leaves=31` (el valor por defecto) y con un valor
reducido, acorde a tu `max_depth`.

**Entrega:** las dos métricas y una frase sobre qué pasó.

> Con una cohorte de unos miles de filas, el valor por defecto suele sobreajustar.
> Es el experimento que fija la lección.

---

### 4. Early stopping, con tres conjuntos

Implementa early stopping usando un conjunto de **validación separado** —no el
de prueba.

**Entrega:** el número de árboles donde se detuvo, la curva de la métrica de
validación, y una frase explicando por qué usar el conjunto de prueba aquí sería
fuga.

> **Trampa.** Pasar `X_test` como `eval_set` «porque es el que tengo a la mano»
> es exactamente la fuga. Sutil, silenciosa, y cambia el resultado.

---

## Parte B — La búsqueda

### 5. Define el espacio, y justifícalo

Escribe el espacio de búsqueda para Optuna. Para **cada** parámetro, una frase:
por qué ese rango y no otro.

| Parámetro | Rango | Por qué |
|---|---|---|
| `learning_rate` | | |
| `max_depth` / `num_leaves` | | |
| `min_child_weight` | | |
| `subsample`, `colsample_bytree` | | |
| `reg_lambda` | | |

> **Trampa.** `learning_rate` entre 0.0001 y 1 desperdicia la mitad de las
> pruebas en configuraciones absurdas. Un rango log-uniforme estrecho y razonado
> rinde mucho más que uno amplio.

---

### 6. Optimiza, con pruning

Corre al menos **100 trials** con Optuna, con pruning activado.

**Entrega:** el mejor resultado, cuántos trials se podaron, y las dos gráficas:
historia de optimización e **importancia de hiperparámetros**.

> Mira la gráfica de importancia: lo normal es que **dos o tres** parámetros
> expliquen casi todo. Si es tu caso, dilo — es la confirmación empírica de
> Bergstra & Bengio sobre tus propios datos.

---

## Parte C — Antes de seguir: la censura

### 7. ¿Tu desenlace tiene censura?

Revisa tu cohorte y reporta:

- cuántos sujetos llegaron completos al horizonte de predicción
- cuántos se **censuraron antes** (se perdieron de seguimiento, o se acabó el
  periodo de observación)
- qué hiciste con ellos en los modelos de la parte A

**Entrega:** los tres números y la decisión que tomaste, declarada.

> Si los excluiste, perdiste datos **y no al azar**. Si los contaste como «no
> evento», afirmaste algo que no sabes. Las dos opciones son defendibles; lo que
> no se vale es no haberlo decidido.
>
> Es la censura de la sesión 17, cobrándose aquí.

---

## Parte D — El número honesto

### 8. CV simple contra nested CV

Estima el desempeño de **dos** formas:

| | Cómo |
|---|---|
| **A** | buscas hiperparámetros con CV, reportas el mejor valor observado |
| **B** | **nested CV**: bucle interno busca, bucle externo estima |

**Entrega:** los dos números, lado a lado, y la diferencia.

> La diferencia suele ser de varios puntos de AUC, y **A siempre sale mejor**.
> Ése es el punto: A no es el desempeño esperado, es el máximo de muchos
> intentos.
>
> Si no puedes correr nested CV completo por tiempo, usa menos trials en el
> bucle interno y **dilo**. No lo omitas.

---

### 9. Intervalos de confianza

Para cada métrica que reportes, calcula un intervalo de confianza del 95 %
(bootstrap sobre el conjunto de prueba es suficiente).

**Entrega:** las métricas con su intervalo.

> Con 120 eventos, un AUROC de 0.78 puede traer un intervalo de ±0.06. Eso
> cambia por completo cómo se lee la tabla de la actividad 8.

---

### 10. La prueba, una vez

Evalúa el mejor modelo en el conjunto de prueba. **Una sola vez.**

**Entrega:** las métricas finales y la comparación con lo que esperabas según
nested CV.

---

## Parte E — El veredicto

### 11. La tabla comparativa

```text
modelo                AUROC (IC 95%)   AUPRC   tiempo   ¿explicable?
--------------------  ---------------  ------  -------  ------------
DummyClassifier
Regresión logística
k-NN
SVM (RBF)
Random Forest
XGBoost (ajustado)
LightGBM (ajustado)
```

**Entrega:** la tabla completa, con **todos** los modelos de la parte A más el ajustado.

---

### 12. ¿Valió la pena?

Un párrafo que responda, **con los números de tu tabla**:

- ¿se traslapan los intervalos de confianza entre la logística y el mejor modelo?
- ¿alguna familia quedó claramente descartada, y por qué supuesto suyo?
- si se traslapan, ¿puedes afirmar que uno es mejor?
- ¿la ganancia justifica perder interpretabilidad en un modelo que va a tocar
  pacientes?
- ¿cuánto costó, en tiempo de cómputo y de tu tiempo?

> **«El modelo complejo no demostró ser mejor en esta cohorte» es un resultado,
> no un fracaso.** Es también el más honesto con cohortes de unos miles de
> pacientes, y el que un revisor va a respetar.

---

### 13. Registra todo

Usa MLflow para registrar parámetros, métricas y artefactos de cada corrida.

**Entrega:** la carpeta `mlruns/`, el modelo final exportado, y una captura de la
interfaz (`mlflow ui`) mostrando las corridas.

> Si la tabla de la actividad 8 la tuviste que armar a mano buscando en tus
> notas, es que no registraste mientras trabajabas. Con MLflow, esa tabla se
> genera sola.

---

## Entregable

1. `optimizacion.ipynb` — el flujo completo
2. `espacio_busqueda.md` — los rangos con su justificación
3. `comparacion.md` — la tabla final y el párrafo del veredicto
4. `mlruns/` — el registro de experimentos
5. El modelo final exportado

---

## Criterios de evaluación

- [ ] La semilla está fijada y anotada
- [ ] El early stopping usa un conjunto de validación **separado** del de prueba
- [ ] Cada rango del espacio de búsqueda tiene su justificación escrita
- [ ] Se corrieron ≥100 trials con pruning, y se muestran las dos gráficas
- [ ] Se reportan **ambas** estimaciones: CV simple y nested CV
- [ ] Todas las métricas llevan intervalo de confianza
- [ ] El conjunto de prueba se usó **una sola vez**
- [ ] Se entrenaron todas las familias del catálogo, con escalado sólo donde hace falta
- [ ] Se explica el resultado de cada familia en términos de lo que **supone**
- [ ] Se reporta la censura de la cohorte y qué se hizo con ella, declarado
- [ ] La tabla comparativa incluye todos los modelos, con tiempo de entrenamiento
- [ ] El veredicto sobre complejidad está argumentado **con números**, no con impresiones
- [ ] Los experimentos están en MLflow
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Prueba **CatBoost** sobre tus categóricas sin agrupar y compara contra tu
  versión agrupada por jerarquía (sesión 23). ¿Gana lo automático o lo pensado?
- **Modelos de supervivencia.** Si tu cohorte tiene censura importante, un
  clasificador binario tira información: ignora *cuándo* ocurrió el evento y
  obliga a inventar una respuesta para los censurados. Con `scikit-survival`
  ajusta un **Cox** y un **Random Survival Forest**, y reporta el **índice C** de
  ambos. Los *hazard ratios* del Cox son, además, lo que un clínico ya sabe leer.
- Prueba un **SVM con kernel RBF** y compáralo con el resto. Fíjate en el tiempo
  de entrenamiento: suele ser el argumento que lo descarta, no la métrica.
- Entrena una **red neuronal tabular** (`MLPClassifier`) y comprueba en tus propios
  datos lo que dice Grinsztajn: ¿le gana al boosting? ¿cuánto te costó ajustarla?
- Repite la búsqueda con **random search** del mismo presupuesto y compara con
  Optuna. Con 100 trials la diferencia puede ser menor de lo que esperas.
- Entrena sobre los **faltantes nativos** de XGBoost (sin imputar) y compara con
  tu pipeline de imputación + indicador. ¿Cuál gana en tu cohorte?

---

## Estructura sugerida

```
s24-xgboost-lightgbm-hpo/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab24: <descripción breve>` y solicita revisión.
