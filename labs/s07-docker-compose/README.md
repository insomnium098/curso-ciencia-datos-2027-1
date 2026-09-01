# Laboratorio 07 — Levantar un stack clínico completo

**Sesión 07:** Docker Compose y Servicios Multi-contenedor
**Bloque:** II — Ingeniería de software para científicos

## Objetivo

Escribir **desde cero** un `compose.yml` que levante un entorno de análisis
clínico —base de datos, cliente web y notebook— y que **otra persona pueda
levantar sin instrucciones adicionales**.

La prueba de éxito no es que arranque en tu máquina: es que arranque en la de
alguien más con un solo comando.

---

## Antes de empezar

**Este laboratorio necesita Docker instalado en tu equipo.** Es el tema de la
sesión: no se puede hacer en Google Colab. Ver
[`docs/entorno-alumno.md`](../../docs/entorno-alumno.md).

**No copies el `compose.yml` de la carpeta `solucion/`.** Está ahí para
comparar al final, y compararlo antes te quita el ejercicio completo.

---

## Actividades

### 1. El stack mínimo

Escribe un `compose.yml` con **Postgres** y **Adminer**. Levántalo, entra a
Adminer desde tu navegador y conéctate a la base.

Antes de escribir nada, decide y anota: ¿qué puertos publicas y por qué?
¿Cuáles **no** hacen falta?

**Entrega:** el archivo y una captura de Adminer conectado.

---

### 2. Los servicios se hablan por nombre

Añade un servicio de **Jupyter** y conéctate desde un notebook a Postgres
usando el **nombre del servicio**, no una IP ni `localhost`.

Después, desde tu máquina (fuera de Docker), conéctate a la misma base.
La cadena de conexión es distinta.

**Entrega:** las dos cadenas de conexión, funcionando, y una frase explicando
por qué difieren.

---

### 3. Inicializar la base

Monta una carpeta `initdb/` con al menos dos scripts SQL numerados que creen
los esquemas `cdm` y `results` y alguna tabla de prueba.

Después haz este experimento: **modifica un script y vuelve a hacer `up`.**
¿Se aplicó el cambio? Explica por qué, y qué hace falta para que sí se aplique.

---

### 4. Persistencia: qué sobrevive y qué no

Inserta datos en la base. Después ejecuta, en orden, y anota qué queda vivo:

| Comando | ¿Sobreviven los datos? | ¿Por qué? |
|---|---|---|
| `docker compose restart` | | |
| `docker compose down` + `up` | | |
| `docker compose down -v` + `up` | | |

Añade también un **bind mount** para tus notebooks y comprueba que editas desde
tu editor y el cambio se ve dentro del contenedor sin reconstruir nada.

---

### 5. Healthchecks de verdad

Configura un `healthcheck` real para Postgres y haz que Jupyter **espere a que
esté sano**, no sólo a que haya arrancado.

Demuéstralo con evidencia:

- `docker compose ps` mostrando el estado `healthy`
- Un `up` desde cero donde el notebook conecta a la primera, sin *connection refused*

**Pista:** provoca primero el fallo (sin healthcheck) para tener con qué comparar.
Si tu máquina es rápida quizá no falle siempre — eso también es parte de la
lección: es un bug intermitente.

---

### 6. Configuración fuera del archivo

Mueve **toda** la configuración a `.env`: usuario, contraseña, base, puertos,
token de Jupyter.

- `.env` va en `.gitignore`; `.env.example` sí se versiona
- Usa la forma que **falla al arrancar** si falta una variable crítica
  (`${VAR:?mensaje}`) para al menos la contraseña
- Comprueba que `grep -ri "password" compose.yml` no devuelve ningún secreto

**Entrega:** ambos archivos y la salida de esa comprobación.

---

### 7. Un servicio opcional

Pon Adminer detrás de un **perfil** para que sólo se levante cuando lo pidas.
Demuestra los dos casos: `up` sin él y `--profile dev up` con él.

---

### 8. Depurar a propósito

Rompe el stack deliberadamente: cambia la contraseña en un solo lugar, de modo
que Jupyter no pueda conectarse. Ahora depúralo aplicando el método de la
sesión, **documentando qué viste en cada paso**:

1. `docker compose ps` — ¿qué está vivo? ¿qué estado tiene?
2. `docker compose logs <servicio>` — ¿qué dijo antes de fallar?
3. `docker compose exec <servicio> ...` — ¿qué ve desde adentro?

**Entrega:** la bitácora de esos tres pasos y el diagnóstico final.

---

### 9. La prueba real de reproducibilidad

Borra todo (`down -v`), clona tu propio repositorio **en otra carpeta**, copia
`.env.example` a `.env` y levanta.

Si necesitaste algún paso manual no documentado, **arréglalo en el README**.
Repite hasta que sea limpio.

Después: pide a un compañero que lo haga en su máquina. Su reporte es parte
del entregable.

---

### 10. Comparar con la referencia

Ahora sí, abre `solucion/compose.yml` y anota **tres diferencias** con el tuyo.
Para cada una: ¿es mejor la suya, la tuya, o son equivalentes? Justifica.

> No hay una sola forma correcta. Se evalúa el criterio, no el parecido.

---

## Entregable

Carpeta `stack/` en tu repositorio con: `compose.yml`, `.env.example`,
`initdb/`, `README.md` propio (cómo levantarlo en tres líneas) y un
`bitacora.md` con las mediciones y experimentos (persistencia, healthcheck,
depuración, comparación final).

---

## Criterios de evaluación

- [ ] `cp .env.example .env && docker compose up` funciona en un clon limpio,
      sin pasos manuales extra
- [ ] Ningún secreto aparece en `compose.yml` ni en el repositorio
- [ ] Sólo se publican los puertos que un humano necesita, y está justificado
- [ ] El healthcheck impide que el notebook arranque antes que la base, con evidencia
- [ ] La tabla de persistencia está completa y correcta
- [ ] El experimento de `initdb` explica correctamente por qué no se re-ejecuta
- [ ] La bitácora de depuración muestra el método `ps → logs → exec`
- [ ] Un compañero levantó tu stack y lo confirma
- [ ] La comparación con la solución tiene tres diferencias razonadas

---

## Si te atoras

- **«connection refused» al arrancar:** falta el healthcheck. Actividad 5.
- **Cambié `initdb/` y no pasó nada:** el volumen ya tenía datos. `down -v`.
- **«port is already allocated»:** algo más usa ese puerto en tu máquina
  (¿un Postgres instalado?). Cambia el lado del host: `"5433:5432"`.
- **El notebook no ve mis archivos:** revisa el bind mount; la ruta de la
  izquierda es la tuya, la de la derecha la del contenedor.
- **Funciona en mi máquina pero no en la de mi compañero:** eso es exactamente
  lo que busca la actividad 9. Casi siempre es una variable de `.env` que
  no documentaste en `.env.example`.

## Estructura sugerida

```text
s07-docker-compose/
├── README.md          # este archivo (el enunciado)
├── solucion/          # NO abrir hasta la actividad 10
└── tu-entrega/
```
