# Material complementario — Sesión 28

**Claude Code y Desarrollo Asistido por IA**
Bloque VI — Inteligencia artificial generativa

> Estas herramientas cambian cada mes. Lo que está aquí se verificó al preparar el
> semestre 2027-1; los **conceptos** —instrucciones del proyecto, permisos, modo
> plan, hooks, subagentes— son estables, los nombres de comandos no tanto.

---

## 1. La evidencia

- **Becker J, Rush N, Barnes B, Rein D.** *Measuring the Impact of Early-2025 AI on
  Experienced Open-Source Developer Productivity.* METR, julio 2025.
  [arXiv:2507.09089](https://arxiv.org/abs/2507.09089)

  El ensayo aleatorizado de la figura: 16 desarrolladores experimentados, 246
  tareas reales de sus propios repositorios, cada una asignada al azar a «con IA» o
  «sin IA». Con IA tardaron **19 % más**; esperaban ir 24 % más rápido y, ya
  terminado, creyeron haberlo hecho 20 % más rápido.

  Léelo también por su tabla de lo que **no** afirma: es un modelo de cómo se
  escribe la sección de limitaciones de un estudio.

- **[Actualización de METR, 24 de febrero de 2026](https://metr.org/blog/2026-02-24-uplift-update/)**

  El segundo estudio (finales de 2025) estima una aceleración, pero los autores lo
  declaran **poco fiable** por sesgo de selección: muchos desarrolladores ya no
  aceptaban trabajar sin IA y entre 30 y 50 % retuvo las tareas donde más esperaban
  ganar. Es el mejor ejemplo reciente de cómo la adopción de una tecnología puede
  volver imposible medir su efecto — y vale la pena leerlo con ojos de diseño de
  estudio, no de tecnología.

- **Spracklen J, Wijewickrama R, Sakib AHMN, Maiti A, Viswanath B, Jadliwala M.**
  *We Have a Package for You! A Comprehensive Analysis of Package Hallucinations by
  Code Generating LLMs.* USENIX Security 2025.
  [arXiv:2406.10279](https://arxiv.org/abs/2406.10279)

  576 000 muestras de código de 16 modelos: los comerciales inventan en promedio al
  menos **5.2 %** de los paquetes que recomiendan y los abiertos **21.7 %**, con
  205 474 nombres inventados distintos. Es la base del ataque llamado
  *slopsquatting*.

---

## 2. Claude Code

La documentación oficial está en **code.claude.com/docs**. Para esta sesión
bastan estas páginas:

| Página | Para qué |
|---|---|
| **[Buenas prácticas](https://code.claude.com/docs/en/best-practices)** | la más útil de todas; casi toda la clase sale de aquí |
| **[Memoria: `CLAUDE.md` y `AGENTS.md`](https://code.claude.com/docs/en/memory)** | cómo escribir las instrucciones del proyecto |
| **[Modos de permiso](https://code.claude.com/docs/en/permission-modes)** | manual, plan, automático, lista de permitidos |
| **[Hooks](https://code.claude.com/docs/en/hooks-guide)** | lo que debe pasar siempre, sin depender del modelo |

Lo que conviene retener de la página de buenas prácticas, porque vale para
cualquier asistente:

- casi todo sale de una restricción: **la ventana se llena y el desempeño cae**
- **dale una forma de verificar su trabajo**: sin prueba, «parece terminado» es su
  única señal
- **explora, planea, implementa, commitea** — y sáltate el plan si el cambio cabe
  en una frase
- tras **dos correcciones fallidas**, sesión nueva con un mejor pedido
- los *checkpoints* **no sustituyen a `git`**

---

## 3. Instrucciones del proyecto para cualquier herramienta

- **[AGENTS.md](https://agents.md)**
  Formato abierto, en Markdown y sin campos obligatorios, que leen Codex, Cursor,
  el agente de Copilot, Jules, Aider, opencode, Gemini CLI (configurándolo) y Claude
  Code. Lo administra la Agentic AI Foundation, bajo la Linux Foundation.

  Si escribes un solo archivo de instrucciones, que sea éste: tu repositorio
  queda listo para el asistente que use quien venga después.

---

## 4. Alternativas

| Herramienta | Qué es |
|---|---|
| **[Codex CLI](https://github.com/openai/codex)** | agente de terminal de OpenAI, de código abierto |
| **[Gemini CLI](https://github.com/google-gemini/gemini-cli)** | agente de terminal de Google, de código abierto |
| **[opencode](https://opencode.ai)** | agente abierto; acepta modelos de cualquier proveedor, incluidos locales |
| **[Aider](https://aider.chat)** | programación en pareja desde la terminal, trabaja directo con `git` |
| **[Hermes Agent](https://github.com/NousResearch/hermes-agent)** | el harness de la sesión 27; independiente del modelo |
| **[Ollama](https://ollama.com)** | para correr el modelo en tu máquina con cualquiera de los abiertos |

> Para el laboratorio cualquiera sirve. Lo que no es negociable es lo que pide
> cada actividad: permisos que se pueden probar, pruebas cuyo valor esperado no
> escribió el modelo, y una revisión hecha por ti.

---

## 5. Para el laboratorio

- **Inker LA, et al.** *New Creatinine- and Cystatin C–Based Equations to Estimate
  GFR without Race.* **N Engl J Med** 2021;385(19):1737-1749.
  [doi:10.1056/NEJMoa2102953](https://doi.org/10.1056/NEJMoa2102953)

  La ecuación CKD-EPI 2021 de la actividad 5. De aquí salen tus valores de
  referencia — calculados por ti, no por el asistente.

---

## La política del curso, desde hoy

A partir de esta sesión el asistente se permite en los laboratorios y en el
proyecto final ([`docs/evaluacion.md`](../docs/evaluacion.md)):

1. se **declara** en `USO_IA.md` qué se generó con asistencia
2. en la revisión tienes que poder **explicar cada línea**
3. lo que no podrías haber escrito tú, no lo puedes revisar — y lo que no revisaste,
   no lo entregues
