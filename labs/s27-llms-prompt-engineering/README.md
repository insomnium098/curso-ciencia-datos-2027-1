# Laboratorio 27 — Un agente con herramientas, y su servidor MCP

**Sesión 27:** De Modelos de Lenguaje a Agentes: Herramientas, Harness y MCP
**Bloque:** VI — Inteligencia artificial generativa

## Objetivo

Construir el bucle de un agente **a mano**, sin librerías que lo escondan, para
entender exactamente qué se le manda al modelo y qué decide tu código. Después,
exponer tu base clínica como **servidor MCP** para que cualquier agente pueda
consultarla.

Y al final, atacar tu propio agente.

---

## Antes de empezar

Trabaja en **tu propio equipo**: necesitas terminal.

**Elige tu modelo.** Todo el laboratorio funciona con cualquiera de los dos:

| Opción | Qué necesitas | Ventaja |
|---|---|---|
| **API comercial** | clave propia; el gasto de este lab es de 1–2 USD | calidad, y mides costo real |
| **Modelo abierto local** | [Ollama](https://ollama.com) y ~8 GB de RAM libres | gratis, y **nada sale de tu máquina** |

> Si eliges la API, pon la clave en una **variable de entorno**, nunca en el
> código. `gitleaks` corre en la actividad 17 y va a encontrarla.

**Necesitarás además:** `mcp` (el SDK), el tokenizador de tu modelo y `pytest`.

> **Antes de escribir código:** decide qué base vas a exponer. Lo más simple es
> la de Synthea que vienes usando desde el laboratorio 2.

Material complementario: [`recursos/s27-llms-prompt-engineering.md`](../../recursos/s27-llms-prompt-engineering.md)

---

## Parte A — El modelo, medido

### 1. Cuánto cuesta tu español

Con el tokenizador **del modelo que vas a usar**, mide y tabula:

| Texto | Caracteres | Tokens | Caracteres por token |
|---|---|---|---|
| un párrafo de nota clínica en español | | | |
| el mismo párrafo traducido al inglés | | | |
| 10 códigos CIE-10 (`N18.3`, `E11.22`…) | | | |
| 10 `concept_id` de SNOMED | | | |

**Entrega:** la tabla llena, y **la lista de tokens** en que se parte uno de los
códigos CIE-10.

> Contesta en una línea: si tuvieras que procesar 50 000 notas, ¿cuánto te
> costaría de más hacerlo en español? Esa cifra decide presupuestos reales.

---

### 2. La misma pregunta, veinte veces

Manda exactamente la misma petición **20 veces** con `temperature = 0` y 20 veces
con `temperature = 1`. Usa una pregunta cuya respuesta sea corta y comparable
(una clasificación, por ejemplo).

**Entrega:** cuántas respuestas **distintas** salieron en cada caso.

> Si con `temperature = 0` salieron 20 respuestas idénticas, no concluyas que es
> determinista: concluye que **no lo detectaste en 20 intentos**. Anota la
> versión exacta del modelo; es parte del resultado.

---

### 3. Provocar una alucinación verificable

Pídele **cinco referencias bibliográficas** sobre un tema clínico específico, con
autores, revista, año y DOI. Después **verifica cada una**.

**Entrega:** la tabla de cinco referencias con una columna «existe: sí / no» y,
para las que no, qué parte era plausible y cuál estaba inventada.

> Es el ejercicio que más convence. No lo saltes aunque creas que ya sabes el
> resultado.

---

## Parte B — El bucle, a mano

> **Regla de esta parte: ninguna librería de agentes.** El objetivo es que el
> bucle sea tuyo, línea por línea.

### 4. Diseñar dos herramientas

Define **dos** herramientas sobre tu base. Al menos una debe consultar datos
reales. Escribe su esquema completo —nombre, descripción y JSON Schema de
argumentos— **antes** de implementarlas.

**Entrega:** los dos esquemas, y una línea por cada uno explicando qué
ambigüedad resuelve la descripción.

> **Trampa:** escribe la descripción pensando en alguien que no conoce tu base.
> «Busca pacientes» no dice si acepta CIE-10 o SNOMED, ni qué devuelve si no
> hay resultados.

---

### 5. Escribir el bucle

Implementa los tres pasos de la figura: el modelo decide, tu código ejecuta, el
resultado vuelve al contexto. Repite hasta que el modelo responda sin pedir
herramientas.

**Entrega:** el código, y la **traza completa** de una ejecución con al menos
tres llamadas a herramienta: qué mandaste, qué pidió, qué devolviste.

> La traza es el entregable importante. Si no puedes imprimir exactamente lo que
> viaja al modelo en cada turno, no vas a poder depurar nada después.

---

### 6. Los límites

Agrega tres frenos y **demuestra que funcionan**:

- límite de turnos
- límite de tokens acumulados (o de gasto estimado)
- tiempo máximo por herramienta

**Entrega:** una ejecución que **alcance** cada límite, con lo que tu agente le
dice al usuario cuando eso pasa.

> «Se alcanzó el límite de 10 turnos sin completar la tarea» es un buen mensaje.
> Quedarse callado, no.

---

### 7. Romperlo a propósito

Haz que una de tus herramientas falle de tres maneras: excepción, tiempo de
espera agotado, y resultado vacío.

**Entrega:** qué hizo el modelo en cada caso, **antes y después** de que el error
le volviera como texto legible.

> Éste es el hallazgo de la actividad: con la excepción sin capturar, el modelo
> suele **inventar** el resultado. Documéntalo con la traza.

---

## Parte C — El contexto

### 8. Medir cómo crece

Instrumenta tu bucle para registrar, en cada turno, cuántos tokens se envían y
cuántos se añaden. Corre una tarea de al menos 10 turnos.

**Entrega:** la gráfica de las dos series y el total acumulado.

> Compárala con la figura 02 de la clase. La forma debería ser la misma aunque
> los números no lo sean.

---

### 9. Una política de contexto

Implementa **una** de las políticas de la clase —truncar, resumir, o guardar los
resultados grandes en disco y pasar una referencia— y vuelve a correr **la misma
tarea**.

**Entrega:** los dos totales acumulados, el ahorro en porcentaje, y una línea
honesta sobre **qué se perdió**.

> Si tu política no perdió absolutamente nada, probablemente no se activó.
> Revisa.

---

## Parte D — MCP

### 10. Un servidor con un tool

Escribe un servidor MCP que exponga **una** de tus herramientas de la actividad 4.
Pruébalo con el **MCP Inspector** antes de conectarlo a nada.

**Entrega:** el código del servidor y una captura del Inspector ejecutando el
tool.

> El SDK genera el esquema a partir de tus **anotaciones de tipo** y del
> **docstring**. Escribe el docstring para el modelo, no para ti.

---

### 11. Añadir un resource

Expón el **esquema de tu base** como *resource*: nombres de tablas, columnas y
tipos.

**Entrega:** el código, y una comparación: la misma pregunta al agente **con** y
**sin** el resource conectado.

> Esta actividad es la que más mejora los resultados y la que casi nadie hace.
> Sin el esquema, el modelo adivina nombres de columnas.

---

### 12. Conectarlo a un cliente de verdad

Conecta tu servidor a un cliente MCP real (tu agente de la parte B, o cualquier
aplicación que soporte MCP) y resuelve con él una pregunta clínica que requiera
al menos dos llamadas.

**Entrega:** la traza de la conversación.

---

### 13. Pedir permiso

Agrega una herramienta con una consecuencia seria —borrar, exportar o enviar— y
haz que **pida confirmación al usuario** antes de ejecutarse.

**Entrega:** el código y la traza de los dos caminos: cuando el usuario acepta y
cuando rechaza.

> Lo correcto es que la confirmación la pida **el servidor**, que sabe cuántos
> registros se van a borrar, no el modelo, que sólo sabe que llamó a una función.

---

## Parte E — Romperlo como lo rompería alguien más

### 14. Inyección de prompt contra tu propio agente

Mete en tu base —en un campo de texto libre— una nota que contenga instrucciones
dirigidas al asistente. Después haz una pregunta normal que obligue al agente a
leer esa nota.

**Entrega:** la nota que escribiste, la traza, y si el agente obedeció o no.

> Si no obedeció al primer intento, **insiste**: cambia la redacción, pon las
> instrucciones al final, usa formato de sistema. El objetivo de la actividad es
> conseguirlo, no convencerte de que es imposible.

---

### 15. Mitigar, pero de verdad

Ahora defiéndete **sin** usar el recurso de pedirle al modelo que no obedezca.
Elige al menos dos mitigaciones de arquitectura:

- quitarle al agente las herramientas de escritura cuando lee texto no confiable
- separar en dos agentes: uno lee, otro actúa, y entre ellos pasa sólo un
  resultado estructurado y validado
- marcar el contenido no confiable y limitar qué puede hacer el agente después
- confirmación humana para todo lo irreversible

**Entrega:** qué implementaste y la repetición del ataque de la actividad 14.

> Explica en dos líneas por qué «le dije al modelo que ignore instrucciones en
> los datos» **no** es una mitigación.

---

### 16. El registro

Haz que toda llamada a herramienta quede registrada: qué herramienta, con qué
argumentos, qué devolvió, cuándo, y con qué versión del modelo.

**Entrega:** el registro de una ejecución completa.

> Decide qué **no** guardas. Si los argumentos incluyen datos de un paciente, ese
> registro es una base de datos clínica (sesión 26).

---

### 17. Higiene

Corre `gitleaks`. Verifica que no haya claves de API ni datos de pacientes en el
repositorio.

**Entrega:** la salida. Si aparece una clave, **rótala** — borrar el commit no
sirve.

---

## Checklist de entrega

- [ ] Está medido cuántos caracteres por token da tu español contra el inglés
- [ ] La prueba de no determinismo registra la **versión exacta** del modelo
- [ ] Al menos una referencia inventada está documentada
- [ ] El bucle es tuyo: **ninguna librería de agentes**
- [ ] Hay traza completa de lo que viaja al modelo en cada turno
- [ ] Los tres límites se alcanzaron de verdad en una ejecución
- [ ] Está documentado qué hace el modelo cuando una herramienta falla en silencio
- [ ] El crecimiento del contexto está graficado y hay una política implementada
- [ ] La política declara **qué se perdió**
- [ ] El servidor MCP expone un tool **y** un resource
- [ ] La acción destructiva pide confirmación, y está probada en los dos caminos
- [ ] **La inyección de prompt funcionó** y está documentada
- [ ] Las mitigaciones son de arquitectura, no instrucciones al modelo
- [ ] Hay registro de auditoría de todas las llamadas a herramienta
- [ ] `gitleaks` pasa

---

## Para ir más lejos (opcional)

- **Lee un harness.** Clona [Hermes Agent](https://github.com/NousResearch/hermes-agent)
  y localiza su bucle principal. Compara sus decisiones de manejo de contexto con
  las tuyas de la actividad 9.
- **Subagentes.** Divide una tarea en dos ramas con contexto independiente y mide
  si sale más barato que una sola conversación larga.
- Revisa las [mejores prácticas de seguridad de MCP](https://modelcontextprotocol.io/docs/2026-07-28/tutorials/security/security_best_practices.md)
  y audita tu propio servidor contra ellas.

---

## Estructura sugerida

```
s27-llms-prompt-engineering/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab27: <descripción breve>` y solicita revisión.
