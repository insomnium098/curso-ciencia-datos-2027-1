# Laboratorio 20 — Data lake clínico en S3

**Sesión 20:** Amazon S3: Almacenamiento de Datos Clínicos con boto3
**Bloque:** IV — Cómputo en la nube

## Objetivo

Montar el almacenamiento **real** de tu proyecto final: versionado, cifrado, no
público, organizado en zonas y consultable sin descargar nada.

Lo que construyas hoy lo vas a seguir usando en las sesiones 21 a 25. No es un
ejercicio desechable.

---

## Antes de empezar

**Necesitarás:** la cuenta y el perfil `tesis` de la sesión 19, `boto3`,
`pandas`, `pyarrow`, `s3fs` y `duckdb`.

> **Las reglas siguen siendo las mismas:**
>
> 1. **Datos sintéticos o públicos.** Nunca datos de pacientes reales.
> 2. **Cero credenciales** en el repositorio. `gitleaks` vuelve a correr.
> 3. El presupuesto de la sesión 19 sigue activo. Revísalo al terminar.

Material complementario: [`recursos/s20-aws-s3-boto3.md`](../../recursos/s20-aws-s3-boto3.md)

---

## Parte A — El bucket

### 1. Los cuatro interruptores

Crea un bucket con:

- **Block Public Access** activado (verifica que también esté a nivel cuenta)
- **Versionado** activado
- **Cifrado en reposo** (SSE-S3 basta)
- Una etiqueta `Proyecto=tesis` para poder atribuir el costo

**Entrega:** captura de la configuración y el nombre del bucket.

> **Trampa.** El nombre del bucket es único **en todo el mundo**, no en tu
> cuenta. Si `datos-tesis` ya existe, no es un error tuyo. Usa algo como
> `omop-tesis-<tus-iniciales>-<4 dígitos>`.

---

### 2. Las tres zonas

Define y **documenta** tu estructura:

```text
raw/        como llegó, nadie la reescribe
staging/    limpio y tipado, regenerable
curated/    particionado, en Parquet, listo para analizar
```

**Entrega:** `arquitectura_datalake.md` explicando qué va en cada zona, cómo se
nombran los archivos y cuál es tu esquema de particionado — **con su porqué**.

> Si tu partición es por año y mes, explica por qué no por sitio, o al revés. La
> partición correcta es la que coincide con cómo vas a **filtrar** después.

---

### 3. Subir con `sync`

Sube los datos sintéticos del curso a `raw/` con `aws s3 sync`. Vuelve a
correrlo sin cambiar nada y observa qué hace.

**Entrega:** la salida de las dos corridas y una frase explicando la diferencia.

---

## Parte B — El módulo

### 4. `s3util/`

Escribe un módulo con, al menos: `subir`, `descargar`, `listar` y `existe`.

Requisitos:

- recibe el **nombre del perfil**, nunca credenciales
- captura `ClientError` y **distingue** al menos `NoSuchKey`, `NoSuchBucket` y
  `AccessDenied`, con un mensaje útil para cada uno
- tiene pruebas con `pytest` (sesión 5)

**Entrega:** el módulo y las pruebas pasando.

> **Trampa.** `AccessDenied` casi nunca significa «no tengo acceso al bucket»:
> significa que falta **una** acción concreta sobre **un** ARN concreto. Si te
> aparece, vuelve al simulador de la sesión 19 antes de ampliar la política.

---

### 5. Pagina de verdad

`list_objects_v2` devuelve **1 000 objetos como máximo**. Tu función `listar`
tiene que devolver todos.

**Entrega:** una demostración con **más de 1 000 objetos**: súbelos (archivos
diminutos bastan), lista, y muestra que el conteo coincide. Incluye la prueba
automatizada.

> **Esta es la actividad que más se reprueba.** El código sin paginación
> funciona perfectamente con 50 objetos y miente con 1 500, sin lanzar ningún
> error. Si tu demostración usa menos de 1 000 objetos, no demuestra nada.
>
> Usa el **paginador** de boto3, no un `while` a mano con `ContinuationToken`.

---

## Parte C — Formatos

### 6. CSV a Parquet particionado

Toma el CSV más grande que tengas, conviértelo a Parquet particionado y escríbelo
en `curated/`.

**Entrega:** la estructura resultante y el código de conversión.

---

### 7. Mide, no estimes

Compara CSV y Parquet en tu propio equipo:

| | CSV | Parquet |
|---|---|---|
| tamaño en disco | | |
| leer el archivo completo | | |
| leer **una** columna | | |

**Entrega:** la tabla con números **medidos**, el código que los midió, y una
gráfica. Reporta la **mediana de al menos tres corridas**, no una sola.

> La figura de la sesión (`slides/figuras/s20/02-csv-vs-parquet.png`) se generó
> exactamente así, con un script que puedes leer: `tools/figuras_s20.py`. Tus
> números van a ser distintos a los míos, y está bien — lo que no está bien es
> inventarlos.

---

### 8. Leer sin descargar

Lee el Parquet desde S3 de **dos** formas, sin bajar el archivo a disco:

1. con `pandas` + `s3fs`, pidiendo sólo algunas columnas
2. con `duckdb`, con una consulta SQL que filtre por partición

**Entrega:** el notebook con ambas, y una frase sobre cuál usarías en tu
proyecto y por qué.

> **Trampa.** Si tu consulta de DuckDB tarda lo mismo filtrando por partición que
> sin filtrar, tu particionado no está funcionando. Revisa el formato de las
> llaves (`anio=2026/`, con el signo igual).

---

## Parte D — Protegerse del error humano

### 9. Ciclo de vida y presigned URL

- Configura una regla de ciclo de vida (por ejemplo, a Standard-IA a los 30 días)
  y documenta qué decidiste y por qué
- Genera una **presigned URL** de 1 hora para un objeto, pruébala y documenta qué
  pasa cuando caduca

**Entrega:** la regla, la URL (ya caducada) y la explicación.

---

### 10. Borra algo y recupéralo

Borra un objeto, demuestra que desapareció, y recupéralo usando el versionado.

**Entrega:** la secuencia completa, con la explicación de qué es un *delete
marker* y por qué el objeto no se había borrado realmente.

> Éste es el ejercicio que justifica el versionado. Hazlo una vez aquí y no se te
> olvida nunca.

---

## Entregable

1. `arquitectura_datalake.md` — zonas, nombres, particionado y su porqué
2. `s3util/` — el módulo, con pruebas que pasan
3. `benchmark.ipynb` — la comparación medida, con gráfica
4. `operaciones.md` — ciclo de vida, presigned URL y la recuperación

---

## Criterios de evaluación

- [ ] El bucket **no** es públicamente accesible (se verificará)
- [ ] Versionado y cifrado activos desde la creación
- [ ] La estructura de zonas está documentada, con el porqué del particionado
- [ ] `listar` pagina correctamente, **demostrado con más de 1 000 objetos**
- [ ] El módulo distingue al menos tres códigos de `ClientError`
- [ ] Hay pruebas con `pytest` y pasan
- [ ] La comparación CSV/Parquet trae números medidos, mediana de ≥3 corridas
- [ ] La lectura desde S3 funciona **sin descargar** el archivo completo
- [ ] Se demuestra la recuperación de un objeto borrado
- [ ] Cero credenciales en el repositorio (`gitleaks` limpio)
- [ ] El código está versionado con commits descriptivos

---

## Al terminar

- **No borres el bucket**: lo vas a usar en las sesiones 21 a 25
- Revisa Cost Explorer con la etiqueta `Proyecto=tesis`
- Si subiste los 1 000 objetos de prueba, **bórralos** (y nota que el versionado
  los conserva: expíralos con una regla)

---

## Para ir más lejos (opcional)

- Monta el mismo análisis sobre un dataset del
  [Registry of Open Data on AWS](https://registry.opendata.aws/) sin descargarlo
  a tu máquina. Es el corolario de la sesión 19 en acción.
- Compara el tamaño de tu Parquet con compresión `snappy` frente a `zstd`.
- Escribe una política de bucket que **niegue** cualquier acceso que no venga por
  HTTPS, y verifica que sigue funcionando tu código.

---
