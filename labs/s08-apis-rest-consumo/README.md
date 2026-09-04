# Laboratorio 08 — Cliente para APIs biomédicas públicas

**Sesión 08:** APIs REST: Consumo de Servicios Web con Python
**Bloque:** II — Ingeniería de software para científicos

## Objetivo

Construir un cliente **robusto** que consulte tres APIs biomédicas reales,
consolide los resultados y —lo más importante— **cuyas pruebas corran sin
conexión a internet**.

Cualquiera puede escribir un `requests.get`. La diferencia profesional está en
lo que pasa cuando la red falla, cuando el servidor te pide calma y cuando la
API cambia su formato sin avisarte.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `requests httpx pydantic pandas` + para las pruebas:
`pytest responses` (o `respx` si usas httpx) y `requests-cache`.

Ninguna de las tres APIs exige llave para este laboratorio. La de NCBI es
opcional y gratuita: sube tu límite de 3 a 10 peticiones por segundo.

> **Sé cortés.** Son servicios públicos y gratuitos. Cachea, no lances bucles
> sin pausa y respeta lo que digan sus términos de uso.

---

## Actividades

### 1. Explorar antes de programar

Elige una condición clínica relacionada con tu tesis. Antes de escribir código,
abre la documentación de las tres APIs y responde por escrito:

| | Endpoint que usarás | Parámetros clave | ¿Cómo pagina? | ¿Límite de tasa? |
|---|---|---|---|---|
| NCBI E-utilities (PubMed) | | | | |
| ClinicalTrials.gov v2 | | | | |
| openFDA | | | | |

**Pista:** haz la primera petición en el navegador o con `curl`. Ver el JSON
crudo antes de parsearlo ahorra horas.

---

### 2. Una petición decente

Escribe la consulta más simple posible a ClinicalTrials.gov, con las **tres
líneas que nunca se omiten**: `timeout`, `params=` y `raise_for_status()`.

Después rompe cada una a propósito y documenta qué pasa:

- Sin `raise_for_status()`, pide un identificador inexistente. ¿Qué error ves?
- Con `params=` mal usado (concatenando la cadena tú), busca algo con espacios
  o acentos. ¿Qué pasa?

**Entrega:** el código correcto y la bitácora de los dos fallos provocados.

---

### 3. Paginación sin agotar la memoria

Trae **al menos 300 registros** de ClinicalTrials.gov usando un **generador**
que no cargue todo en memoria.

Demuestra que es un generador de verdad: procesa los resultados uno a uno e
imprime el uso de memoria (lo que aprendiste en el laboratorio 2).

**Entrega:** la función y la comparación de memoria contra la versión que
acumula todo en una lista.

---

### 4. El cliente robusto

Encapsula todo en una clase o módulo con:

- `timeout` en todas las peticiones
- **Reintentos con backoff exponencial**, sólo para métodos idempotentes y
  sólo para los códigos que lo merecen (429 y 5xx; los 4xx **no**)
- Respeto al encabezado `Retry-After`
- Una `Session` reutilizada
- Caché en disco

**Entrega:** el módulo y una tabla que justifique tu política de reintentos:
para cada código (400, 401, 404, 429, 500, 503), ¿reintentas? ¿por qué?

---

### 5. Guardar el crudo

Antes de transformar nada, **guarda las respuestas tal cual llegan** en
`data/raw/`, con la fecha de descarga y los parámetros usados.

Explica en tres renglones por qué esto importa para la reproducibilidad de tu
tesis.

> Recuerda: `data/` está en el `.gitignore`. Se documenta cómo obtenerlo, no
> se sube.

---

### 6. Validar en la frontera

Define modelos de **Pydantic** para las tres fuentes, con validaciones que
tengan sentido clínico (número de inscritos ≥ 0, fechas coherentes, estados
dentro de un conjunto conocido).

Procesa los datos crudos: los registros válidos siguen, los malformados se
registran y se saltan.

**Entrega:** cuántos registros llegaron, cuántos pasaron la validación, y una
muestra de tres que fallaron **con el motivo**.

---

### 7. Consolidar

Normaliza las tres fuentes a DataFrames (`pd.json_normalize` te ayudará con el
JSON anidado) y guárdalos en Parquet.

Responde con ellos al menos dos preguntas, por ejemplo: ¿cuántos ensayos
activos hay para tu condición y dónde? ¿cuáles son los eventos adversos más
reportados del fármaco principal? ¿cómo evolucionó la publicación en PubMed
por año?

---

### 8. Pruebas sin red

**La actividad más importante.** Escribe pruebas con `responses` (o `respx`)
que simulen las respuestas del servidor, de modo que **`pytest` funcione con
el wifi apagado**. Cubre como mínimo:

- Respuesta 200 con JSON válido
- Un **429** seguido de un 200: comprueba que reintentó y terminó bien
- Un **500** persistente: comprueba que se rinde tras N intentos
- Un **404**: comprueba que **no** reintenta
- JSON con un campo faltante: comprueba que Pydantic lo rechaza

**Verificación:** desconecta el wifi y corre `pytest`. Debe pasar todo.

---

### 9. Medir la cortesía

Instrumenta tu cliente para contar **cuántas peticiones reales** hiciste durante
todo el laboratorio, y cuántas resolvió la caché.

**Entrega:** los dos números y una reflexión de dos renglones: si mil personas
corrieran tu script a la vez, ¿tumbarías el servicio?

---

## Entregable

En tu repositorio: módulo `clientes/` con las pruebas, `notebooks/consolidado.ipynb`
con el análisis de las tres fuentes, y un `README.md` que documente cómo obtener
los datos (endpoints, parámetros y fecha).

**No subas los datos crudos ni ninguna llave de API.**

---

## Criterios de evaluación

- [ ] Ninguna petición carece de `timeout`
- [ ] La política de reintentos distingue 4xx de 429/5xx y está justificada
- [ ] La paginación usa un generador, con la comparación de memoria medida
- [ ] Los datos crudos se guardan antes de transformarlos
- [ ] Pydantic rechaza registros malformados y se reporta cuántos y por qué
- [ ] **`pytest` pasa completo con la red desconectada** (evidencia requerida)
- [ ] Las pruebas cubren 200, 429→200, 500 persistente, 404 y JSON inválido
- [ ] Ninguna llave de API aparece en el repositorio
- [ ] El conteo de peticiones reales contra caché está reportado

---

## Si te atoras

- **Recibes 429 constantemente:** estás pidiendo demasiado rápido. Añade pausa
  entre peticiones y activa la caché antes de seguir depurando.
- **`r.json()` truena con un error raro:** te faltó `raise_for_status()`;
  estás intentando parsear una página de error HTML.
- **La API devuelve XML y esperabas JSON:** varias APIs de NCBI lo hacen por
  defecto. Busca el parámetro `retmode`.
- **Las pruebas siguen tocando la red:** no estás registrando bien la URL en
  `responses`. Verifica que coincida exactamente, incluidos los parámetros.
- **`json_normalize` deja columnas con nombres larguísimos:** es lo esperado
  con JSON anidado. Usa `record_path` y `meta`, o renombra después.
