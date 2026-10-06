# Laboratorio 18 — Auditoría de una definición de cohorte

**Sesión 18:** Cohortes Avanzadas: Factibilidad, Atrición y Herramientas OHDSI
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Someter **tu propia cohorte de la sesión 17** a diagnóstico: medir lo que costó
cada criterio, buscar lo que dejaste fuera sin darte cuenta, y averiguar si tus
conclusiones sobrevivirían a mover una decisión arbitraria.

Es la primera vez en el curso que el trabajo consiste en **buscarle defectos a
algo tuyo**. Esa es la habilidad.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas duckdb jupysql matplotlib`

**Punto de partida:** tu cohorte de la sesión 17, ya en `results.cohort`, y el
SQL que la generó con un CTE por componente.

> Si tu cohorte final quedó muy chica, **no la rehagas para que salga más
> grande**. Trabaja con la que tienes y documenta la limitación: ése es
> exactamente el ejercicio.

Material complementario: [`recursos/s18-cohortes-avanzadas-ohdsi.md`](../../recursos/s18-cohortes-avanzadas-ohdsi.md)

---

## Parte A — Factibilidad, a posteriori

### 1. Los tres conteos

Responde para tu cohorte, con números:

1. ¿cuántos pacientes entraron?
2. ¿cuánto seguimiento tienen después del índice? (mediana y cuartiles)
3. ¿cuántas **veces ocurre el desenlace** que te interesa en ese seguimiento?

**Entrega:** los tres números y un veredicto en una frase: ¿este estudio es
factible con estos datos, sí o no?

> **La pregunta que importa es la 3.** Una cohorte de 50 000 pacientes con 8
> eventos no sirve para estudiar ese evento. Como regla de dedo, un modelo de
> riesgo suele pedir ~10 eventos por variable: con 8 eventos no hay modelo, por
> más pacientes que tengas.
>
> Si tu respuesta es «no es factible», **dilo y explica qué cambiarías**:
> ¿la pregunta, el desenlace, o la fuente de datos? Esa respuesta vale completa.

---

## Parte B — Atrición

### 2. La tabla, paso a paso

Reconstruye la tabla de atrición de tu cohorte, una fila por criterio, en el
orden en que los aplicaste:

```text
| paso | N | % del inicial | pérdida respecto al paso anterior |
```

**Entrega:** la tabla completa, y un párrafo sobre qué criterio costó más y si
ese precio vale la pena.

> **Trampa.** Los porcentajes tienen que cuadrar. Si tu tabla no suma, casi
> siempre es porque un `JOIN` duplicó filas en algún paso — el error de la
> sesión 16, otra vez.

---

### 3. El orden importa

Reordena **dos** criterios de tu definición y vuelve a construir la tabla.

**Entrega:** las dos tablas lado a lado y la verificación de que el **N final es
el mismo**. Si no lo es, tus criterios no son independientes: explica por qué.

> Esto demuestra algo que casi nadie reporta: la tabla de atrición no mide el
> costo «objetivo» de un criterio, porque depende del orden. Por eso el orden se
> declara.

---

### 4. El diagrama de flujo

Convierte la tabla en un diagrama vertical tipo CONSORT, con las cajas de N y
las pérdidas al costado. Usa `matplotlib` o Mermaid.

**Entrega:** la figura, en calidad presentable. Va a tu tesis tal cual.

---

## Parte C — Diagnóstico

### 5. Incidencia por año y por grupo etario

Calcula y grafica la incidencia de entrada a tu cohorte por año calendario, y
por grupo de edad.

**Entrega:** las dos gráficas y una interpretación.

> **Qué buscar:** un pico artificial al inicio de la base (ahí digitalizaron, no
> hubo epidemia), una caída al final (los últimos meses aún no se capturan
> completos), o escalones que coincidan con cambios de sistema. Todos son
> hallazgos sobre tus datos, no sobre la enfermedad.

---

### 6. ¿Qué códigos metieron a la gente?

Desglosa tu evento índice: para cada `concept_id` de tu concept set, cuántos
pacientes entraron **por él**.

**Entrega:** la tabla ordenada, y el porcentaje que aporta el concepto más
frecuente.

> Es revelador con frecuencia incómoda: a menudo el 90 % de la cohorte entra por
> **un solo código**. Si es tu caso, tu definición es efectivamente ese código y
> el resto del concept set es decorativo. Dilo.

---

### 7. Conceptos huérfanos

Busca códigos que **aparecen con frecuencia en tu base**, se parecen a lo que
buscabas, y **no** están en tu concept set.

Una forma de hacerlo a mano: busca en `CONCEPT` por texto los términos de tu
condición, quédate con los que tienen registros en tu base, y réstale los que ya
incluiste.

**Entrega:** al menos **un candidato real**, con la decisión por escrito de si
entra o no, y por qué.

> Es el único diagnóstico que detecta lo que **falta**. Todo lo demás audita lo
> que ya pusiste.

---

### 8. Lee el SQL que no escribiste

Entra a la [demo pública de ATLAS](https://atlas-demo.ohdsi.org/) y reconstruye
**tu** definición de la sesión 17 con la interfaz: concept set, evento inicial,
criterios con sus ventanas, estrategia de salida.

Después genera el SQL (`Export → SQL`) y compáralo con el tuyo.

**Entrega:** una lista de **tres cosas** que CIRCE hace y tú no hiciste, con una
frase sobre si cada una importa en tu caso o no.

> Casi siempre aparecen: el manejo explícito de `OBSERVATION_PERIOD`, la
> deduplicación de eventos en la misma fecha, y los límites exactos de las
> ventanas (¿el día 0 cuenta?).
>
> **No copies el SQL.** Es largo e ilegible a propósito, y está escrito para
> correr en cinco motores distintos. Lo que te sirve es la lista de casos borde.
>
> La demo pública trae **datos sintéticos**: sirve para aprender la herramienta,
> no para sacar resultados.

---

## Parte D — Sensibilidad

### 9. Tres variantes

Construye tu cohorte con lavado de **180**, **365** y **730** días.

**Entrega:** los tres N y la caracterización de las tres (edad, sexo, seguimiento
mediano, tres comorbilidades frecuentes).

---

### 10. Cuantificar el traslape

¿Cuántos pacientes están en las tres? ¿Cuántos sólo en la más laxa?

**Entrega:** la tabla de traslape y una figura. La de la sesión
(`slides/figuras/s18/02-sensibilidad.png`) te sirve de modelo.

> **Trampa.** Con lavados anidados, la cohorte de 730 días debería ser un
> **subconjunto** de la de 365, y ésta de la de 180. Verifícalo. Si no se cumple,
> hay un error en tu implementación y vale la pena encontrarlo.

---

### 11. La discusión

Escribe un párrafo —el más importante del entregable— respondiendo:

- ¿qué decisión de diseño afecta más al resultado?
- ¿cuál declaras como tu definición principal, y por qué ésa?
- ¿qué limitación de esta cohorte mencionarías tú mismo antes de que te la señalen?

> Declarar la definición principal **antes** de mirar resultados es lo que separa
> un análisis de sensibilidad de un p-hacking. Aquí todavía no tienes resultados,
> así que es el momento honesto de decidirlo.

---

## Entregable

`diagnostico_cohorte.md`, con:

1. Los tres conteos de factibilidad y el veredicto
2. La tabla de atrición, en los dos órdenes, y el diagrama de flujo
3. Las gráficas de incidencia, con su interpretación
4. El desglose del evento índice, los conceptos huérfanos encontrados y las tres
   diferencias contra el SQL de ATLAS
5. Las tres variantes, el traslape y la discusión final

Todo versionado, con las figuras regenerables desde el código.

---

## Criterios de evaluación

- [ ] Los tres conteos de factibilidad están, y el que se discute es el de **eventos**
- [ ] La tabla de atrición suma correctamente y el orden está declarado
- [ ] Se verifica que el N final no cambia al reordenar criterios
- [ ] El diagrama de flujo es presentable sin retoques
- [ ] Se interpreta la gráfica de incidencia como información sobre **los datos**, no sólo sobre la enfermedad
- [ ] El análisis de huérfanos identifica al menos un candidato real, con decisión escrita
- [ ] Se identifican tres casos borde que CIRCE cubre y la implementación propia no
- [ ] Se verifica que las tres variantes están anidadas
- [ ] La definición principal se declara y se justifica
- [ ] La discusión reconoce al menos una limitación propia, sin que nadie se la haya señalado
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Explora la [LEGEND basic viewer](https://data.ohdsi.org/LegendBasicViewer/)
  para ver cómo se presentan los resultados de un estudio de red real sobre
  4.9 millones de pacientes y nueve bases de datos.
- Si tienes R a mano, corre [CohortDiagnostics](https://ohdsi.github.io/CohortDiagnostics/)
  sobre tu cohorte y compara sus hallazgos con los tuyos. ¿Encontró algo que se
  te pasó?
- Escribe el protocolo de tu estudio con la plantilla
  [HARPER](https://drugepi.gitlab-pages.partners.org/harper/) y féchalo. Si vas a
  usar esta cohorte en tu tesis, hazlo ahora, antes de ver resultados.

---

## Estructura sugerida

```
s18-cohortes-avanzadas-ohdsi/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab18: <descripción breve>` y solicita revisión.
