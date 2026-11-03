# Material complementario — Sesión 27

**De Modelos de Lenguaje a Agentes: Herramientas, Harness y MCP**
Bloque VI — Inteligencia artificial generativa

> Ésta es la página del curso que más rápido envejece. La especificación de MCP
> citada aquí es la **`2026-07-28`**; verifica la versión vigente antes de citar
> nada en una tesis.

---

## 1. El modelo

- **[Tokenizador: mide el tuyo](https://github.com/openai/tiktoken)**
  Para la actividad 1. Si usas otro proveedor, usa **su** tokenizador: los
  vocabularios no son intercambiables y los conteos tampoco.

- **[The Illustrated Transformer](https://jalammar.github.io/illustrated-transformer/)** — Jay Alammar
  Si te quedaste con ganas de la arquitectura. Es la explicación visual
  canónica, y sigue siendo la mejor puerta de entrada.

> Deliberadamente **no** hay aquí una lista de «técnicas de prompting». La razón
> es la de la clase: el lugar donde esas técnicas siguen importando es la
> descripción de tus herramientas y las instrucciones del sistema, y eso se
> aprende midiendo con tu propio conjunto de casos, no leyendo catálogos.

---

## 2. Agentes y harness

- **[Hermes Agent](https://github.com/NousResearch/hermes-agent)** — Nous Research
  Harness de código abierto (MIT), independiente del modelo. Lo citamos en clase
  porque **se puede leer entero**: el bucle, el manejo de contexto, los límites
  y los permisos están ahí, sin magia.

  Lo interesante para discutir: crea «skills» a partir de tareas que resolvió y
  las reutiliza después. Pregúntate qué significa eso en un entorno donde las
  acciones tocan pacientes — un comportamiento aprendido que nadie revisó es
  justo lo que la sesión 26 llamaría un modelo que se actualiza solo.

  Documentación: `hermes-agent.nousresearch.com`

- **Claude Code** es otro harness, con otras decisiones de diseño.
  Es la **sesión 30** completa, así que aquí sólo queda nombrado.

---

## 3. MCP — Model Context Protocol

La documentación oficial es buena y corta. Estas cuatro páginas son todo lo que
necesitas para el laboratorio:

| Página | Para qué |
|---|---|
| **[Introducción](https://modelcontextprotocol.io/docs/getting-started/intro)** | qué es y por qué, en cinco minutos |
| **[Arquitectura](https://modelcontextprotocol.io/docs/2026-07-28/learn/architecture.md)** | host, cliente, servidor; los primitivos; los mensajes JSON-RPC reales |
| **[Construir un servidor](https://modelcontextprotocol.io/docs/2026-07-28/develop/build-server.md)** | el tutorial que sigue la actividad 10 |
| **[Mejores prácticas de seguridad](https://modelcontextprotocol.io/docs/2026-07-28/tutorials/security/security_best_practices.md)** | antes de conectar nada que importe |

Y dos herramientas:

- **[MCP Inspector](https://github.com/modelcontextprotocol/inspector)** — prueba
  tu servidor sin conectarlo a un agente. Úsalo **antes** de la actividad 12:
  depurar un servidor a través de un modelo es innecesariamente difícil.
- **[Servidores de referencia](https://github.com/modelcontextprotocol/servers)** —
  implementaciones oficiales. Leer el de sistema de archivos enseña más que
  cualquier tutorial.

### Lo que conviene no perderse de la especificación

- **Los tres primitivos del servidor** son *tools*, *resources* y *prompts*. Casi
  todo el mundo usa sólo el primero; exponer el esquema de tu base como
  **resource** es lo que más mejora los resultados.
- **Elicitation** es el primitivo con el que el servidor pide confirmación al
  usuario. Es el mecanismo correcto para el humano en el bucle.
- *Sampling* y *logging* quedaron **deprecados** en la versión `2026-07-28`.
- La página de seguridad detalla por qué **un servidor MCP local corre con los
  privilegios de quien lo lanzó**, y qué se recomienda al respecto: mostrar el
  comando completo antes de ejecutarlo, aislar en contenedor y preferir `stdio`.
- También trae la sección de **minimización de alcances**: es el principio de
  privilegio mínimo de la sesión 19, aplicado a herramientas.

---

## 4. Correr un modelo en tu máquina

- **[Ollama](https://ollama.com)**
  La vía más corta para la opción local del laboratorio. Vale la pena aunque
  acabes usando una API: tener un modelo que corre sin red cambia lo que te
  atreves a probar con datos sensibles.

> El argumento clínico para lo local no es el costo: es que **nada sale de tu
> red**. Un modelo abierto peor, corriendo en tu infraestructura, suele ser más
> fácil de defender ante un comité que uno excelente al que le mandas notas.

---

## 5. Antes de la siguiente sesión

La **28** usa LLMs para extraer información de texto clínico, y la **29** mete
tus documentos en la ventana de contexto con RAG. Las dos dan por sabido lo de
hoy: tokens, contexto, herramientas.

Si sólo vas a leer una cosa antes de la 28, que sea la página de **arquitectura
de MCP**: la vas a usar en las tres sesiones que quedan del bloque.
