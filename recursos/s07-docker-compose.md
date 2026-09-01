# Material complementario — Sesión 07

## Docker Compose y Servicios Multi-contenedor

*Bloque II — Ingeniería de software para científicos*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Orquestar varios servicios interdependientes con un solo archivo declarativo
- Configurar redes, volúmenes, variables de entorno y healthchecks entre contenedores
- Levantar una arquitectura realista: base de datos + API + notebook + interfaz
- Separar configuración de código y manejar secretos de forma segura

## Documentación oficial

- ★ [**Docker Compose — Overview**](https://docs.docker.com/compose/)
  Punto de entrada. Empieza por el 'Quickstart'.
- [**Compose file reference**](https://docs.docker.com/reference/compose-file/)
  La especificación completa, atributo por atributo. La consultarás siempre.
- [**Compose — Startup order**](https://docs.docker.com/compose/how-tos/startup-order/)
  Por qué `depends_on` no basta y cómo se resuelve con healthchecks. La causa #1 del «a mí no me funciona».
- [**Compose — Environment variables**](https://docs.docker.com/compose/how-tos/environment-variables/)
  Precedencia e interpolación. Léelo: el orden shell > .env > default confunde a todo el mundo.
- [**Compose — Profiles**](https://docs.docker.com/compose/how-tos/profiles/)
  Servicios opcionales. El nombre del perfil lo inventas tú. Dos detalles que sorprenden: `--profile "*"` activa todos, y si nombras un servicio explícitamente en la línea de comandos, corre aunque su perfil no esté activo.
- [**Compose — Merge y múltiples archivos**](https://docs.docker.com/compose/how-tos/multiple-compose-files/)
  `compose.override.yml` y cómo se combinan. Base para separar desarrollo de producción.
- [**Dockerfile HEALTHCHECK**](https://docs.docker.com/reference/dockerfile/#healthcheck)
  La otra forma de declarar salud: dentro de la imagen, en vez del compose.

## Redes, volúmenes y datos

- ★ [**Compose — Networking**](https://docs.docker.com/compose/how-tos/networking/)
  El DNS interno por nombre de servicio, que es la confusión número uno de la sesión.
- [**Docker — Volumes**](https://docs.docker.com/engine/storage/volumes/)
  Volúmenes con nombre: cuándo, cómo respaldarlos y cómo migrarlos.
- [**Docker — Bind mounts**](https://docs.docker.com/engine/storage/bind-mounts/)
  La otra mitad: tu carpeta dentro del contenedor. Es lo que hace usable el desarrollo.
- [**Postgres — imagen oficial**](https://hub.docker.com/_/postgres)
  Su README documenta `/docker-entrypoint-initdb.d`, las variables y por qué los scripts sólo corren la primera vez.

## Ejemplos para copiar ideas

- ★ [**Awesome Compose**](https://github.com/docker/awesome-compose)
  Repositorio oficial con decenas de stacks completos: Postgres, FastAPI, Jupyter y más.
- [**Jupyter Docker Stacks**](https://jupyter-docker-stacks.readthedocs.io/)
  Imágenes oficiales de Jupyter, sus variantes y cómo extenderlas.
- [**Adminer**](https://hub.docker.com/_/adminer)
  Cliente web de base de datos en un solo contenedor. Un archivo PHP, cero configuración.
- [**OHDSI Broadsea**](https://github.com/OHDSI/Broadsea)
  Un Compose real y grande: ATLAS, WebAPI, HADES y Postgres. Léelo cuando termines el laboratorio.

## Operación y depuración

- ★ [**Compose CLI — referencia**](https://docs.docker.com/reference/cli/docker/compose/)
  Todos los subcomandos. `ps`, `logs`, `exec` y `down -v` son los del día a día.
- [**Docker — exec contra run**](https://docs.docker.com/reference/cli/docker/container/exec/)
  Entrar a un contenedor vivo frente a crear uno nuevo. Confundirlos cuesta tardes.
- [**Play with Docker**](https://labs.play-with-docker.com/)
  Entorno de práctica en el navegador, sin instalar nada. Útil si tu equipo no da.

## Seguridad y más allá

- ★ [**Docker — Secrets en Compose**](https://docs.docker.com/compose/how-tos/use-secrets/)
  La forma correcta de pasar credenciales cuando `.env` no basta.
- [**OWASP Docker Security Cheat Sheet**](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
  Checklist práctico de endurecimiento.
- [**Kubernetes — Conceptos básicos**](https://kubernetes.io/es/docs/concepts/overview/)
  A dónde escala esto cuando el proyecto crece. Contexto, no requisito del curso.
- [**Nextflow**](https://www.nextflow.io/docs/latest/index.html)
  Orquestación de pipelines científicos con contenedores. Pasos que corren y terminan, no servicios que viven.

## Cómo usar este material

1. **Antes de la clase:** revisa los recursos marcados con ★ (30–45 min).
2. **Durante el laboratorio:** ten abiertas las páginas de documentación oficial.
3. **Después:** elige un recurso de profundización relacionado con tu proyecto final.


