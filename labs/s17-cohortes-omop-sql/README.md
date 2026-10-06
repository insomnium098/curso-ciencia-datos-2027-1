# Laboratorio 17 — Definir e implementar una cohorte de nuevo usuario

**Sesión 17:** Diseño de Cohortes Clínicas en OMOP con SQL
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Construir **una cohorte completa y defendible**, de principio a fin: la
definición en prosa, el SQL que la implementa, la tabla de atrición que muestra
qué costó cada criterio, y la caracterización de quién quedó dentro.

Esta es la entrega que más se parece a lo que vas a necesitar en tu tesis. Si
sólo conservas un archivo de todo el semestre, que sea éste.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas duckdb jupysql matplotlib`

**Punto de partida:** tu base OMOP de los laboratorios 12–16, tu concept set de
la sesión 14 o 15, y un esquema `results` donde escribir.

> **Revisa `OBSERVATION_PERIOD` antes de confiar en él.** En muchas conversiones
> queda mal construido (un solo periodo que abarca toda la base, o periodos que
> no cubren los eventos). Cuenta cuántas personas tienen periodo, cuánto dura la
> mediana, y cuántos eventos caen **fuera** de él. Si está mal, todo lo demás
> también.

Material complementario: [`recursos/s17-cohortes-omop-sql.md`](../../recursos/s17-cohortes-omop-sql.md)

---

## Parte A — La definición, en español

### 1. Escribe la cohorte en prosa. Primero.

Antes de una sola línea de SQL, escribe `cohorte_definicion.md` con **PICOT**:

| | |
|---|---|
| **Población** | ¿a quién estudias? |
| **Exposición** | ¿qué define la entrada? |
| **Comparador** | ¿contra qué? (si aplica) |
| **Desenlace** | ¿qué mides? |
| **Tiempo** | ¿qué ventanas, y por qué ésas? |

Después, los cuatro componentes, cada uno en una o dos frases: evento inicial,
criterios de inclusión, estrategia de salida, censura.

**Entrega:** el documento. Sin SQL todavía.

> Esto no es burocracia. Si no puedes escribir la definición en prosa, no la
> tienes clara, y el SQL va a ser una sucesión de `AND` que nadie —ni tú en tres
> meses— podrá auditar.
>
> **Toda ventana temporal que escribas lleva su porqué al lado.** «365 días»
> porque es la convención no basta; di qué pasaría si fueran 180.

---

## Parte B — La implementación

Escribe `cohorte_definicion.sql` con **un CTE por componente**, en este orden.
Después de cada uno, cuenta las filas: ésa es tu tabla de atrición.

### 2. Evento inicial

Usa tu concept set de la sesión 14/15 para encontrar la primera ocurrencia por
persona.

**Entrega:** N de personas con al menos un evento.

> **Trampa.** Una fila por paciente: la **primera** ocurrencia. Verifícalo
> contando `COUNT(*)` y `COUNT(DISTINCT person_id)` sobre el resultado del CTE;
> si no coinciden, tu agregación está mal y todo lo que sigue hereda el error.

---

### 3. Observación previa

Exige **≥365 días** de `OBSERVATION_PERIOD` antes de la fecha índice.

**Entrega:** N después del filtro, y cuántos se perdieron.

> **Trampa 1.** No basta con que exista un `observation_period`: tiene que
> *contener* la fecha índice y extenderse 365 días hacia atrás. Una persona con
> dos periodos separados no tiene 365 días continuos aunque la resta de fechas
> extremas lo sugiera.
>
> **Trampa 2.** Grafica el número de «primeras ocurrencias» por año **antes** de
> aplicar este filtro. Si ves un pico al inicio de la base, no hubo una epidemia:
> es la fecha en que arrancó el sistema, y todos los casos que ya existían
> aparecen ahí de golpe. Ese pico es justo lo que este filtro corrige — inclúyelo
> en tu entrega, antes y después.

---

### 4. Lavado

Exige **cero exposiciones** al fármaco (o cero ocurrencias de la condición) en
los 365 días previos.

**Entrega:** N después del lavado, y la caída.

> Observación previa y lavado son **dos** filtros distintos. Uno dice «te
> estábamos viendo»; el otro, «y no lo tenías». Repórtalos por separado.

---

### 5. Dos criterios de inclusión y dos de exclusión

Con ventanas explícitas, escritos con `EXISTS` / `NOT EXISTS`.

Al menos uno de los cuatro debe ser del tipo **«al menos N ocurrencias en la
ventana W»** — ése no se resuelve con `EXISTS` solo.

**Entrega:** los cuatro criterios, con su ventana, su justificación clínica, y el
N después de cada uno.

> **Trampa.** Si usas `JOIN` en vez de `EXISTS`, un paciente con doce
> diagnósticos aparece doce veces y tu conteo se infla. Mismo error de la sesión
> 16, otro disfraz.

---

### 6. Estrategia de salida

Implementa el fin de exposición continua con **gap de 30 días**, reutilizando el
patrón de *gaps and islands* de la sesión 11.

**Entrega:** la lógica de salida y la distribución de duración en la cohorte.

> **Trampa.** La salida es el **mínimo** entre tu fecha de salida por definición
> y el fin del periodo de observación. Nunca puedes seguir a alguien más allá de
> donde llegan los datos.

---

### 7. Insertar en `results.cohort`

Con las cuatro columnas estándar y un `cohort_definition_id` propio.

**Entrega:** el `INSERT`, y la verificación de que no hay `cohort_end_date`
anterior a `cohort_start_date` ni fechas fuera del periodo de observación.

---

## Parte C — Mirar lo que construiste

### 8. Tabla de atrición

Una fila por paso, con el N que queda y el porcentaje que se perdió.

```text
| paso                          |      N | % que queda |
|-------------------------------|--------|-------------|
| con el evento inicial         |        |             |
| + 365 días de observación     |        |             |
| + lavado sin exposición       |        |             |
| + criterios de inclusión      |        |             |
| cohorte final                 |        |             |
```

**Entrega:** la tabla, y un párrafo sobre qué criterio costó más y si ese precio
vale la pena.

> Si te quedas sin cohorte, **repórtalo**. No aflojes los criterios hasta que
> salga un número bonito: eso es exactamente el sesgo que estos diseños existen
> para evitar.

---

### 9. Caracterizar

De la cohorte final: N, edad **en la fecha índice**, sexo, las diez
comorbilidades más frecuentes en `[-365, 0]`, y el tiempo de seguimiento mediano.

**Entrega:** una «tabla 1» presentable y el histograma del seguimiento.

> **Trampa.** La edad se calcula contra la **fecha índice**, no contra hoy ni
> contra el fin del estudio. Usar `year_of_birth` a secas cambia
> estratificaciones enteras.

---

### 10. Buscar tu propio immortal time

Revisa tu definición con una sola pregunta:

> ¿Algún criterio usa información **posterior** a la fecha índice para decidir si
> alguien entra, o para clasificar su exposición?

**Entrega:** la respuesta, con la justificación. Si encontraste uno, muestra cómo
lo corregiste y cuánto cambió el resultado.

---

## Entregable

1. `cohorte_definicion.md` — la prosa, PICOT y los cuatro componentes
2. `cohorte_definicion.sql` — un CTE por componente, comentado
3. `atricion.md` — la tabla paso a paso
4. `caracterizacion.md` — la tabla 1 y el histograma de seguimiento

Todo versionado en tu repositorio.

---

## Criterios de evaluación

- [ ] La definición en prosa existe y **coincide exactamente** con el SQL
- [ ] Cada ventana temporal tiene justificación escrita, no sólo un número
- [ ] Observación previa y lavado se implementan y se reportan **por separado**
- [ ] Todos los criterios respetan `OBSERVATION_PERIOD`
- [ ] Los criterios usan `EXISTS` / `NOT EXISTS`, no `JOIN`, salvo donde se requiere agregación
- [ ] La salida es el mínimo entre la definición y el fin de observación
- [ ] La tabla de atrición está completa y se discute el criterio más costoso
- [ ] La edad se calcula en la fecha índice
- [ ] Se revisó explícitamente el immortal time bias
- [ ] El código está versionado con commits descriptivos

---

## Para ir más lejos (opcional)

- Parametriza el script para que el concept set entre por una tabla: el mismo
  SQL debe servir para otra cohorte sin tocar la lógica.
- Construye la misma cohorte en [ATLAS](https://atlas-demo.ohdsi.org/) y compara
  el SQL que genera CIRCE con el tuyo. Es largo y feo a propósito; mira qué
  casos borde cubre que tú no cubriste.
- Llena la plantilla [HARPER](https://drugepi.gitlab-pages.partners.org/harper/)
  para tu estudio. Es lo que te van a pedir si publicas.

---

## Estructura sugerida

```
s17-cohortes-omop-sql/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab17: <descripción breve>` y solicita revisión.
