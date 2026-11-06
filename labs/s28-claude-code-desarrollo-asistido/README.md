# Laboratorio 28 — Tu repositorio, trabajado con un asistente

**Sesión 28:** Claude Code y Desarrollo Asistido por IA
**Bloque:** VI — Inteligencia artificial generativa

## Objetivo

Usar un asistente de código sobre **tu propio repositorio del curso** como lo
usaría un profesional: con instrucciones del proyecto, sin acceso a datos ni
secretos, con la prueba antes que la implementación, y revisando lo que genera
como si lo hubiera escrito otra persona.

Y, de paso, **medir** si te hace más rápido en vez de suponerlo.

---

## Antes de empezar

**Elige tu asistente.** Cualquiera sirve: Claude Code, Codex, Copilot, Cursor,
Gemini CLI, o uno abierto (opencode, Aider o Hermes Agent con un modelo local
vía Ollama). Anota en tu entrega **la herramienta, su versión y el modelo**.

> Todo el laboratorio está escrito en conceptos —instrucciones del proyecto,
> permisos, modo plan, hooks, sesión nueva— que existen en todas. Donde tu
> herramienta no tenga algo, la actividad te dice qué hacer en su lugar.

**Punto de partida:** tu repositorio con los laboratorios anteriores. Trabaja en
una **rama nueva** (`lab28`) y haz commit antes de cada actividad.

> **A partir de hoy** el asistente se permite en los laboratorios 29 y 30 y en el
> proyecto final, con la condición de `docs/evaluacion.md`: se declara en
> `USO_IA.md` y en la revisión tienes que poder explicar cada línea.

Material complementario: [`recursos/s28-claude-code-desarrollo-asistido.md`](../../recursos/s28-claude-code-desarrollo-asistido.md)

---

## Parte A — Antes de tocar nada

### 1. Tu pronóstico

**Antes de usar el asistente**, elige dos tareas de tamaño parecido para las
actividades 5 y 6. Para cada una escribe cuánto tiempo crees que te tomaría
**sin** asistente y **con** asistente.

**Entrega:** la tabla de pronósticos, con fecha y hora. No la modifiques después.

> Es la mitad del experimento de METR. La otra mitad es la actividad 15.

---

### 2. El `AGENTS.md` de tu proyecto

Escribe el `AGENTS.md` de tu repositorio. Como mínimo: los comandos para correr
pruebas y figuras, las convenciones clínicas que el agente no adivinaría
(vocabularios, fecha índice, unidades) y una sección de lo que **nunca** debe
hacer.

Después, ponlo a prueba con tres tareas pequeñas y anota si respetó cada regla.

**Entrega:** el archivo y una tabla regla por regla: ¿la siguió?

> **Trampa:** para cada línea pregúntate si quitarla haría que se equivoque. Si
> tu archivo pasa de 40 líneas, probablemente sobra la mitad — y con ella se
> pierde la regla que importaba.

---

### 3. Cerrar el acceso a datos y secretos, y quitarle los commits

Configura tu herramienta para que el agente **no pueda leer** `data/` ni `.env`,
y para que **no pueda hacer `git commit` ni `git push`**: desde hoy los commits
los haces tú, después de revisar. Tiene que ser un **permiso o una exclusión**, no
una instrucción en `AGENTS.md`.

Después **intenta romperlo**: pídele explícitamente que abra un archivo de
`data/` y que haga un commit.

**Entrega:** la configuración y la transcripción de los dos intentos fallidos.

> Si tu herramienta no permite negar lecturas, la defensa es estructural: los
> datos viven **fuera** del directorio que abres con el agente. Documenta cuál
> usaste.

---

## Parte B — El flujo

### 4. Explorar sin tocar

En modo de solo lectura (plan, «ask», o el que tenga tu herramienta), pídele que
te explique cómo se construye tu cohorte del laboratorio 17.

Después **verifica tres afirmaciones concretas** que hizo contra el código.

**Entrega:** las tres afirmaciones, la línea de código que las confirma o las
contradice, y si alguna era falsa.

> Las explicaciones de código heredado suenan seguras. Ésta es la actividad que
> te enseña cuánto confiar en ellas.

---

### 5. La prueba primero: CKD-EPI 2021

Vas a implementar `egfr(creatinina, edad, sexo)` con la ecuación **CKD-EPI 2021**
sin raza.

1. **Tú**, sin el asistente, buscas la ecuación en la publicación original y
   calculas a mano **tres valores de referencia** (al menos uno de cada sexo y uno
   por debajo y otro por encima del punto de quiebre de la creatinina)
2. **Tú** escribes la prueba con esos tres valores
3. **El asistente** implementa la función hasta que la prueba pase

**Entrega:** las tres referencias con su cálculo, la prueba, la función, y
**cuántos intentos** necesitó el asistente.

> Inker LA, et al. *N Engl J Med* 2021;385(19):1737-1749. Los valores de
> referencia **no** los puede escribir el asistente: si lo hace, la prueba
> compara al modelo consigo mismo.

---

### 6. Refactorizar con red

Pídele al asistente que refactorice código de un laboratorio anterior que ya
tenga pruebas (por ejemplo, tu construcción de variables del laboratorio 23).
Antes, haz que planee; revisa el plan; después, que implemente.

**Entrega:** el plan, el diff, y la salida de las pruebas antes y después.

> Si las pruebas cambiaron durante la refactorización, explica por qué. Un agente
> que no logra que las pruebas pasen a veces **las modifica** para que pasen.

---

### 7. Corregir dos veces, y empezar de cero

Busca —o provoca— una situación en la que tengas que corregir al asistente dos
veces sobre lo mismo. Después abre una **sesión nueva** con un pedido que
incorpore lo que aprendiste.

**Entrega:** los dos pedidos (el original y el nuevo) y qué cambió en el resultado.

---

## Parte C — Revisar

### 8. La revisión de cinco preguntas

Toma el código que generó el asistente en las actividades 5 y 6 y revísalo con
las cinco preguntas de la clase: ¿hace lo que pedí?, ¿qué hace cuando falla?,
¿inventó algo?, ¿las pruebas prueban algo?, ¿tocó lo que no le pedí?

**Entrega:** una tabla hallazgo por hallazgo, con la línea y la gravedad.

---

### 9. Las dependencias

Lista **toda** dependencia que el asistente agregó o sugirió en este laboratorio.
Para cada una: ¿existe en PyPI?, ¿quién la mantiene?, ¿cuántas descargas tiene?,
¿hacía falta?

**Entrega:** la tabla, y las dependencias que quitaste.

---

### 10. ¿Tus pruebas detectan algo?

Introduce **a propósito** tres errores en la función `egfr()`: cambia un
coeficiente, invierte el sexo, y usa la ecuación sin el punto de quiebre.
Corre las pruebas cada vez.

**Entrega:** cuáles de los tres errores detectó tu prueba.

> Si alguno pasó sin que fallara nada, tu prueba es decorativa en ese punto.
> Agrega el caso que faltaba y repite.

---

### 11. Un revisor con contexto limpio

En una **sesión nueva** (o con un subagente, si tu herramienta lo tiene), pide que
revise el diff de la actividad 6 contra el plan. Pídele sólo fallas que afecten la
corrección.

> Si tienes acceso a la revisión automática de pull requests de Copilot, ésta es
> la actividad para probarla: abre el PR y compara lo que encuentra con lo que
> encontró la sesión nueva. Un revisor de otro proveedor es la versión más fuerte
> del contexto limpio.

**Entrega:** lo que encontró, clasificado en «real» y «ruido», con una línea de
justificación para cada uno.

---

### 12. Los errores de datos clínicos

Revisa todo el código generado en este laboratorio buscando los seis errores de
la tabla de la clase: fuga temporal, código no estándar, unidades mezcladas,
nulos que desaparecen, prueba tautológica y preprocesamiento antes de dividir.

**Entrega:** para cada uno, «encontrado» con la línea, o «no aplica» con la razón.

---

## Parte D — Lo determinista

### 13. Algo que pase siempre

Haz que las pruebas corran **automáticamente** sin que se lo pidas: con un hook
de tu herramienta (por ejemplo, al terminar cada edición) o, si no tiene hooks,
con `pre-commit` como en la sesión 5.

**Entrega:** la configuración y una ejecución donde el mecanismo detuvo algo que
fallaba.

---

### 14. Sin interfaz

Si tu herramienta tiene modo no interactivo, úsalo para una tarea repetitiva
(docstrings, formato) con **sólo las herramientas necesarias** permitidas.

**Entrega:** el comando, la lista de herramientas permitidas y el diff.

> Si tu herramienta no lo tiene, entrega en su lugar media cuartilla sobre qué
> tarea de tu proyecto automatizarías así y con qué permisos.

---

## Parte E — Medir y declarar

### 15. La medición

Registra cuánto tardaste **de verdad** en las tareas de las actividades 5 y 6, y
compáralo con tu pronóstico de la actividad 1.

**Entrega:** la tabla pronóstico contra medición, y un párrafo honesto.

> Dos tareas no son un experimento, y no vas a concluir nada general. El objetivo
> es más modesto: saber si **tu** percepción coincide con **tu** reloj.

---

### 16. `USO_IA.md`

Escribe la declaración que vas a usar desde hoy en el curso: qué herramienta y
modelo, qué partes se generaron con asistencia, qué revisaste y cómo, y qué
decidiste tú.

**Entrega:** el archivo. Después de hoy, cada laboratorio lo lleva.

---

### 17. Higiene

Corre `gitleaks` sobre tu repositorio y confirma que no hay datos de pacientes.

**Entrega:** la salida. Si apareció algo, **rótalo**.

---

## Checklist de entrega

- [ ] El pronóstico de tiempos está fechado **antes** de usar el asistente
- [ ] `AGENTS.md` está probado regla por regla
- [ ] El acceso a `data/` y `.env` está cerrado por permiso o por estructura, **y se intentó romper**
- [ ] El agente no puede hacer commit ni push; **todos los commits son tuyos**
- [ ] Hay tres afirmaciones de la exploración verificadas contra el código
- [ ] Los valores de referencia de `egfr()` salen **de la publicación**, calculados por ti
- [ ] Las pruebas detectan los tres errores introducidos a propósito
- [ ] Toda dependencia nueva está verificada o eliminada
- [ ] La revisión de contexto limpio separa hallazgos reales de ruido
- [ ] Las pruebas corren solas, por hook o por `pre-commit`
- [ ] La medición de tiempos se comparó con el pronóstico
- [ ] `USO_IA.md` existe y es honesto
- [ ] `gitleaks` pasa

---

## Para ir más lejos (opcional)

- **Un servidor MCP de la sesión 27, conectado a tu asistente.** Conecta el
  servidor de OMOP que escribiste y pídele al asistente que construya una consulta
  de cohorte usando el *resource* del esquema. Compara con la misma petición sin
  el servidor conectado.
- **Una skill.** Si tu herramienta las tiene, empaqueta como skill el procedimiento
  para construir una tabla de atrición (sesión 18) y úsala en dos cohortes.
- **Modelo local.** Repite la actividad 5 con un modelo abierto vía Ollama y
  compara el número de intentos.

---

## Estructura sugerida

```
s28-claude-code-desarrollo-asistido/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab28: <descripción breve>` y solicita revisión.
