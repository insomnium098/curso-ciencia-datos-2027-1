# Laboratorio 06 — Containerizar tu paquete de análisis

**Sesión 06:** Ambientes Virtuales, Dependencias y Docker
**Bloque:** II — Ingeniería de software para científicos

## Objetivo

Empaquetar `clinlab` (laboratorio 5) en una **imagen reproducible, ligera y sin
secretos**, publicada automáticamente desde CI.

El entregable no es «que funcione»: es que **otra persona, en otra máquina,
obtenga exactamente el mismo entorno** — y que puedas demostrar cuánto pesa,
qué vulnerabilidades tiene y por qué el build tarda lo que tarda.

---

## Antes de empezar

**Este laboratorio necesita Docker instalado en tu equipo.** Es el tema de la
sesión: no se puede hacer en Google Colab. Ver
[`docs/entorno-alumno.md`](../../docs/entorno-alumno.md).

Verifica antes de empezar:

```bash
docker run --rm hello-world
```

**Punto de partida:** tu repositorio `clinlab` del laboratorio 5, con su
`pyproject.toml` y su suite de pruebas.

> **Apple Silicon (M1–M4):** algunas imágenes sólo existen para amd64 y correrán
> emuladas, lentas. Si te topas con eso, documéntalo — es un hallazgo válido.

---

## Actividades

### 1. Congelar las dependencias

Genera un **lockfile determinista** de tu proyecto (con `uv`, `pip-compile` o el
que prefieras) y versiónalo.

Después demuestra que sirve: en el lockfile aparecen dependencias **transitivas**
que nunca declaraste. Enumera tres y explica de cuál de tus dependencias
directas viene cada una.

**Entrega:** el lockfile y esa explicación.

---

### 2. El primer Dockerfile (a propósito, mal ordenado)

Escribe un Dockerfile que copie **primero el código y después instale las
dependencias**. Construye y **cronometra**.

Ahora cambia una línea de tu código y reconstruye. Cronometra otra vez.

**Entrega:** los dos tiempos y una frase explicando qué pasó.

> Esto no es tiempo perdido: es el experimento que hace que la siguiente
> actividad signifique algo.

---

### 3. Arreglar el orden y medir la diferencia

Reordena: dependencias arriba, código abajo. Repite exactamente el mismo
experimento (build limpio, cambio de una línea, rebuild).

Completa la tabla:

| Escenario | Orden malo | Orden bueno |
|---|---|---|
| Build desde cero | | |
| Rebuild tras cambiar código | | |
| Rebuild tras cambiar una dependencia | | |

**Pista:** `docker build --no-cache` fuerza el build limpio para comparar.

---

### 4. Adelgazar la imagen

Mide el tamaño (`docker images`) y redúcelo con **multi-stage build**.
Objetivo: **menos de 500 MB**.

Documenta qué hiciste y cuánto aportó cada cambio: elección de imagen base,
`--no-cache-dir`, separar etapa de construcción, `.dockerignore`.

**Entrega:** tabla de tamaños antes/después por cada medida aplicada.

> Prueba también con una base `alpine` y **documenta qué pasa**. El resultado
> te va a sorprender; explicar por qué es parte del ejercicio.

---

### 5. `.dockerignore` y el contexto de build

Antes de escribirlo, mira qué le estás mandando a Docker:

```bash
docker build . 2>&1 | head -1     # "Sending build context to Docker daemon..."
```

Escribe un `.dockerignore` y vuelve a mirar. **Entrega:** el tamaño del contexto
antes y después, y la lista de lo que estabas enviando sin querer.

---

### 6. Usuario no-root

Configura la imagen para que **no corra como root**. Demuéstralo:

```bash
docker run --rm tu-imagen id
```

Explica en dos renglones qué riesgo concreto mitiga esto.

---

### 7. Secretos: la demostración incómoda

Construye una imagen de prueba que copie un archivo `.env` con un valor falso
y lo borre en la instrucción siguiente. Después **recupéralo**:

```bash
docker history --no-trunc imagen-de-prueba
docker save imagen-de-prueba -o prueba.tar && tar -xf prueba.tar
```

**Entrega:** evidencia de que recuperaste el valor «borrado», y la versión
correcta de pasar esa configuración (variable de entorno en tiempo de ejecución).

> Borra esa imagen de prueba al terminar. Y nunca uses un secreto real aquí.

---

### 8. Escanear

```bash
docker scout cves tu-imagen        # o: trivy image tu-imagen
```

**Entrega:** cuántas vulnerabilidades críticas y altas encontró, y qué harías
con las tres primeras. No hace falta arreglarlas: hace falta **saber leer el
reporte** y decidir.

---

### 9. Correr las pruebas dentro del contenedor

Haz que la imagen pueda ejecutar tu suite:

```bash
docker run --rm tu-imagen pytest
```

Si tus pruebas pasan en tu máquina pero fallan aquí, **acabas de encontrar una
dependencia oculta de tu entorno local**. Documéntala: es el hallazgo más
valioso del laboratorio.

---

### 10. Publicar desde CI

Extiende el workflow de GitHub Actions para que, en cada push a `main`,
construya la imagen y la publique en **GitHub Container Registry** (`ghcr.io`)
con dos etiquetas: la versión (`0.1.0`) y el SHA del commit.

**Prueba final:** pide a un compañero que corra

```bash
docker run --rm ghcr.io/tu-usuario/clinlab:0.1.0 pytest
```

y obtenga verde sin instalar nada.

---

## Entregable

Repositorio con: lockfile, `Dockerfile` multi-stage, `.dockerignore`, workflow
de publicación, y un `docs/imagen.md` que reúna las mediciones (tiempos de
build, tabla de tamaños, contexto, reporte de escaneo).

Más: la URL de la imagen publicada y la confirmación de un compañero de que
funcionó en su máquina.

---

## Criterios de evaluación

- [ ] El lockfile es determinista y está versionado
- [ ] Los tiempos de build de las actividades 2 y 3 están **medidos**, no estimados
- [ ] La imagen final pesa < 500 MB, con el desglose de qué aportó cada medida
- [ ] El experimento con `alpine` está documentado y **explicado**
- [ ] `docker run --rm imagen id` no devuelve root
- [ ] La demostración del secreto recuperable está completa
- [ ] El escaneo está documentado con una decisión, no sólo el conteo
- [ ] `docker run --rm imagen pytest` da verde
- [ ] Un tercero corrió tu imagen publicada y funcionó

---

## Si te atoras

- **El build tarda muchísimo la primera vez:** es normal. Si tarda igual la
  segunda, tienes mal el orden de las capas — vuelve a la actividad 3.
- **`pip install` falla compilando:** casi seguro estás en `alpine`. Es
  exactamente el hallazgo de la actividad 4.
- **La imagen no baja de 1 GB:** revisa la base. `python:3.11` trae compiladores;
  `-slim` no.
- **CI no puede publicar en ghcr.io:** falta el permiso `packages: write` en el
  workflow.
- **En Mac ARM la imagen no arranca en otra máquina:** construiste para arm64.
  Busca `docker buildx` y `--platform`.

## Estructura sugerida

```text
s06-ambientes-dependencias-docker/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/
```
