# Laboratorio 25 — Evaluación completa del modelo de riesgo

**Sesión 25:** Evaluación Clínica de Modelos: AUROC, Calibración y SHAP
**Bloque:** V — Machine Learning clínico

## Objetivo

Producir **el reporte de evaluación** que acompañaría a una publicación o a un
despliegue: no «mi modelo tiene AUC 0.80», sino a quién se le aplicaría, con qué
corte, qué pasa con los que se escapan, y si de verdad aporta algo.

Es el entregable del bloque V. Lo que escribas aquí es, con pocos cambios, la
sección de resultados de tu tesis.

---

## Antes de empezar

**Necesitarás:** `scikit-learn shap matplotlib pandas numpy`

**Punto de partida:** el mejor modelo de la sesión 24, ya ajustado, y el conjunto
de prueba **sin tocar**.

> **Primera decisión, antes de abrir el notebook:** ¿tu modelo va a **tamizar**,
> **priorizar** o **decidir**? Escríbelo. De esa respuesta sale toda la
> evaluación — y el corte que elijas tiene que ser coherente con ella.

Material complementario: [`recursos/s25-evaluacion-clinica-shap.md`](../../recursos/s25-evaluacion-clinica-shap.md)

---

## Parte A — Discriminación

### 1. Métricas con intervalos

En el conjunto de prueba, calcula **AUROC, AUPRC y Brier**, cada uno con
intervalo de confianza del 95 % por bootstrap (≥1 000 remuestreos).

**Entrega:** las tres métricas con su intervalo, y la **prevalencia** de tu
conjunto de prueba al lado.

> La prevalencia no es decorativa: es la línea base de AUPRC y lo que determina
> el VPP de la actividad 3.

---

### 2. Las tres curvas

Grafica ROC, precisión-recall y la **curva de calibración**, las tres con bandas
de confianza.

**Entrega:** la figura, en calidad presentable.

---

### 3. El VPP en TU población, y en otra

Elige un punto de corte y reporta a ese corte: sensibilidad, especificidad, VPP
y VPN.

Después **recalcula el VPP y el VPN** suponiendo que el mismo modelo se usara en
una población con la mitad de la prevalencia, y con el doble.

**Entrega:** la tabla de tres columnas y un párrafo: ¿en cuál de las tres
poblaciones sería usable?

> Sensibilidad y especificidad no cambian. El VPP sí. Ése es el punto.

---

## Parte B — Calibración

### 4. ¿Está calibrado?

Reporta la curva de calibración con su **pendiente** e **interceptor**, y el
Brier score.

**Entrega:** los tres números y una lectura en prosa: ¿sobreestima, subestima, o
está bien?

> Una pendiente menor que 1 es el patrón típico del sobreajuste: los riesgos
> altos salen demasiado altos y los bajos demasiado bajos.

---

### 5. Recalibra, y mide qué cambió

Aplica **Platt** e **isotónica**, usando datos que el modelo no haya visto.

**Entrega:** una tabla con AUROC y Brier **antes y después** de cada método.

> **Trampa.** La recalibración no cambia el orden, así que tu AUROC debe quedar
> prácticamente **igual**. Si cambió mucho, algo está mal en tu procedimiento.
>
> Si en la sesión 22 o 24 usaste `class_weight` o sobremuestreo, aquí vas a ver
> el daño. Repórtalo: es la confirmación empírica de la advertencia.

---

## Parte C — El umbral

### 6. Tradúcelo a una razón de intercambio

Antes de elegir un corte, construye esta tabla para tu problema:

```text
umbral   falsos positivos tolerados por verdadero   ¿tiene sentido clínico?
  5 %                 19
 10 %                  9
 20 %                  4
 50 %                  1
```

**Entrega:** la tabla, y un párrafo con **la pregunta que le harías a un clínico**
para elegir la fila — que no es «¿qué umbral quieres?».

> Si puedes, hazle la pregunta de verdad a alguien de tu servicio y anota la
> respuesta. Vale más que cualquier optimización.

---

### 7. Elige y justifica

Fija el corte **antes** de volver a mirar el conjunto de prueba. Reporta a ese
corte: sensibilidad, especificidad, VPP y VPN, con la prevalencia al lado.

**Entrega:** las cuatro métricas, el umbral elegido y su justificación.

> **Trampa.** El índice de Youden maximiza sensibilidad + especificidad − 1, lo
> que supone que un falso positivo y un falso negativo cuestan **lo mismo**. Si
> lo usas, dilo y defiéndelo; en clínica casi nunca se cumple.

---

## Parte D — ¿Sirve de algo?

### 8. Curva de decisión

Grafica el beneficio neto del modelo contra «tratar a todos» y «no tratar a
nadie», en el rango de umbrales que tenga sentido clínico para tu problema.

**Entrega:** la figura y **el rango de umbrales** donde tu modelo supera a las
dos alternativas.

> **Si no hay ningún rango donde el modelo gane**, ése es el resultado. Dilo, y
> explica qué significa para tu pregunta.

---

### 9. Traduce a carga de trabajo

A tu corte elegido, responde:

- de cada 100 alertas, ¿cuántas son reales?
- ¿a cuántos pacientes habría que evaluar para encontrar un caso?
- ¿cuántos casos se escapan?

**Entrega:** los tres números, en lenguaje de servicio clínico.

---

## Parte E — Subgrupos

### 10. El promedio esconde

Repite las métricas principales **por subgrupo**: al menos sexo y grupo etario, y
cualquier otro eje relevante a tu pregunta.

**Entrega:** la tabla por subgrupo, con **AUROC y calibración** en cada uno, y los
tamaños de muestra.

> **Reporta los resultados aunque sean incómodos.** Si el modelo funciona peor en
> un grupo, eso es un hallazgo, no un error que esconder — y con muestras chicas,
> los intervalos anchos también son información.
>
> Y revisa tu variable objetivo con la lección de Obermeyer: ¿tu desenlace mide
> lo que crees, o mide acceso a la atención?

---

## Parte F — Explicar

### 11. SHAP global

Genera el **beeswarm** de tu modelo.

**Entrega:** la figura y un párrafo: ¿las variables más importantes tienen
sentido clínico? ¿hay alguna que no debería estar ahí?

> Es tu última oportunidad de **descubrir una fuga**. Si la variable que más pesa
> es administrativa (un identificador, un código de servicio, un conteo de
> registros), vuelve a la sesión 23.

---

### 12. El `dependence plot`

Para las **dos** variables más importantes de tu beeswarm, grafica su valor
contra su valor SHAP.

**Entrega:** las dos figuras y, para cada una, qué forma tiene la relación:

| Si ves | Significa |
|---|---|
| una recta | relación monótona |
| un escalón | el modelo encontró un umbral |
| dispersión vertical | hay interacción con otra variable |

> Si aparece un escalón cerca de un punto de corte clínico conocido, **dilo**: es
> evidencia de que el modelo aprendió algo real y no ruido, y es el argumento más
> convincente que vas a tener frente a un comité.

---

### 13. SHAP local, tres pacientes

Genera el **waterfall** de tres casos del conjunto de prueba:

| Caso | Cuál elegir |
|---|---|
| un **acierto** | predicción alta, evento ocurrió |
| un **falso positivo** | predicción alta, no ocurrió |
| un **falso negativo** | predicción baja, sí ocurrió |

**Entrega:** las tres figuras y, para cada una, una frase sobre qué empujó la
predicción — y en los dos errores, tu hipótesis de por qué se equivocó.

> El falso negativo es el más instructivo: casi siempre revela una variable que
> te faltó construir.

---

### 14. Los límites, por escrito

Un párrafo que responda:

- ¿qué **no** puedes concluir de tu beeswarm?
- si dos de tus variables están correlacionadas, ¿cómo afecta eso al reparto de crédito?
- dada tu tabla de la sesión 24, ¿justificaba el modelo complejo necesitar SHAP
  para entenderlo?

---

## Parte G — El reporte

### 15. TRIPOD+AI

Escribe `reporte_modelo.md` siguiendo el checklist de TRIPOD+AI. Marca **cada
ítem**: cumplido, no aplica, o pendiente.

**Entrega:** el reporte y el checklist marcado.

> Los ítems que queden en «pendiente» son tu lista de trabajo para la tesis. Que
> haya varios es normal; no saber cuáles son, no.

---

## Entregable

1. `evaluacion.ipynb` — todo el análisis, reproducible
2. `reporte_modelo.md` — el reporte con el checklist de TRIPOD+AI
3. `figuras/` — ROC, PR, calibración, curva de decisión, SHAP global, dos `dependence` y los tres locales

---

## Criterios de evaluación

- [ ] Se declaró, antes de evaluar, si el modelo va a tamizar, priorizar o decidir
- [ ] **Toda** métrica reporta intervalo de confianza
- [ ] Se reporta la prevalencia junto a cada métrica que dependa de ella
- [ ] El VPP se recalcula para al menos tres prevalencias distintas
- [ ] La calibración se evalúa **y se discute**, no sólo la discriminación
- [ ] La recalibración se hace con datos no vistos, y se verifica que el AUROC no cambió
- [ ] Hay curva de decisión, con el rango de umbrales donde el modelo aporta (o la constatación de que no aporta)
- [ ] El análisis de subgrupos reporta resultados **aunque sean incómodos**
- [ ] El umbral se tradujo a razón de intercambio y se fijó **antes** de mirar la prueba
- [ ] El beeswarm se revisó buscando fugas
- [ ] Hay `dependence plot` de las dos variables principales, con la forma interpretada
- [ ] Hay un waterfall de un acierto, un falso positivo y un falso negativo
- [ ] El checklist de TRIPOD+AI está completo, con los pendientes identificados
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- **Validación externa.** Si consigues una segunda fuente —otro periodo, otro
  servicio, otro hospital—, evalúa ahí sin reentrenar. Es el estándar de oro, y
  casi siempre el desempeño baja.
- **Validación temporal.** Entrena con los primeros años y evalúa con el último.
  ¿Cuánto cae? Eso es lo que pasaría de verdad.
- Lee a [Rudin (2019)](https://arxiv.org/abs/1811.10154) y escribe media cuartilla
  posicionándote: para **tu** problema, ¿modelo interpretable por diseño, o caja
  negra explicada después?

---

## Estructura sugerida

```
s25-evaluacion-clinica-shap/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab25: <descripción breve>` y solicita revisión.
