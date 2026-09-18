# Laboratorio 12 — Primeros pasos en OMOP CDM

**Sesión 12:** Introducción al OMOP CDM: Arquitectura y Tablas Clínicas
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Convertir tus datos de Synthea a **OMOP CDM** y explorarlos con criterio:
medir la calidad del mapeo, entender la diferencia entre concepto estándar y
valor de origen, y respetar la ventana de observación.

Esta base OMOP es la que usarás **hasta la sesión 18** y la que probablemente
sostenga tu proyecto final.

---

## Antes de empezar

Trabaja donde prefieras, aunque la ruta con Broadsea necesita Docker local.

**Necesitarás:** `pandas duckdb jupysql` y, según la ruta que elijas,
Docker o R.

**Registro obligatorio esta semana:** crea tu cuenta gratuita en
[ATHENA](https://athena.ohdsi.org/). La necesitas en la actividad 3 y en toda
la sesión 14.

**Punto de partida:** tus CSV de Synthea del laboratorio 10.

---

## Actividades

### 1. Elegir ruta de conversión

Hay tres caminos. Elige uno y **justifica** en dos renglones:

| Ruta | Qué implica |
|---|---|
| **ETL-Synthea** (R) | paquete oficial de OHDSI, el camino más directo |
| **dbt-synthea** | el mismo ETL como proyecto de dbt, con tests y linaje (sesión 11) |
| **A mano** (SQL) | escribes tú el mapeo de 3–4 tablas. Más trabajo, más aprendizaje |

> Si eliges la tercera, basta con `person`, `observation_period`,
> `visit_occurrence` y `condition_occurrence`. No intentes las 40 tablas.

---

### 2. Convertir

Ejecuta la conversión y **documenta el proceso**: comandos, versiones,
problemas que encontraste y cómo los resolviste.

**Entrega:** el script o los comandos, más el conteo de filas de cada tabla
OMOP resultante.

---

### 3. Cargar vocabularios

Descarga de ATHENA el subconjunto mínimo de vocabularios (**SNOMED, ICD10CM,
RxNorm, LOINC, ATC**) y cárgalo a tu base, al menos las tablas `CONCEPT`,
`CONCEPT_RELATIONSHIP` y `CONCEPT_ANCESTOR`.

Reporta cuántos conceptos tiene tu `CONCEPT` y cuántos son estándar.

> La descarga tarda. Pídela hoy, no la noche antes de la sesión 14.

---

### 4. Dibujar el modelo

Dibuja el diagrama entidad-relación de las tablas que cargaste, con sus llaves.

Compáralo con la [especificación oficial de la v5.4](https://ohdsi.github.io/CommonDataModel/cdm54.html)
y anota **dos diferencias** entre tu resultado y el estándar. ¿Son errores
tuyos o simplificaciones legítimas del ETL?

---

### 5. La primera métrica de calidad: contar ceros

Calcula el porcentaje de `concept_id = 0` en cada tabla clínica.

**Entrega:** una tabla con el porcentaje por dominio, y tu diagnóstico:
¿el ETL está completo? ¿Qué dominio quedó peor mapeado y por qué crees que fue?

> Es lo primero que se hace al recibir una base OMOP. Si el porcentaje es alto,
> cualquier cohorte que definas perderá pacientes en silencio.

---

### 6. Caracterizar la población

Con SQL, y **siempre con nombres legibles**:

- Número de personas, distribución por sexo y por año de nacimiento
- Mediana de días de observación por persona
- Top 20 de diagnósticos, con `concept_name`
- Número medio de visitas por persona, y por tipo de visita

---

### 7. Estándar contra origen

Elige una condición frecuente y cuéntala de dos formas:

1. Por `condition_concept_id` (el estándar)
2. Por `condition_source_value` (el código original)

**¿Dan el mismo número?** Casi seguro que no. Explica por qué: puede haber
varios códigos de origen mapeando al mismo concepto estándar, o códigos sin
mapear que se fueron al 0.

**Entrega:** ambos conteos y la explicación de la diferencia.

---

### 8. Respetar `OBSERVATION_PERIOD`

Cuenta los eventos de `condition_occurrence` de dos maneras: sin filtrar, y
filtrando sólo los que caen **dentro** de la ventana de observación del paciente.

**Entrega:** los dos números, la diferencia en porcentaje, y dos renglones
sobre qué significaría ignorar esa ventana en un estudio real.

---

### 9. Explorar en ATHENA

Busca en ATHENA los tres conceptos que más usaste. Para cada uno documenta:

- `concept_id`, vocabulario, dominio y si es estándar
- Cuántos conceptos **hijos** tiene (esto prepara la sesión 16)
- Al menos un código de origen que mapea a él

**Entrega:** una tabla con esos hallazgos.

---

### 10. Comparar con una base de referencia

Descarga [Eunomia](https://github.com/OHDSI/Eunomia) o levanta el CDM de
demostración de [Broadsea](https://github.com/OHDSI/Broadsea) y corre **las
mismas consultas** de la actividad 6.

**Entrega:** tabla comparativa. ¿Tu base se parece a una base OMOP real?
¿En qué difiere y por qué?

---

## Entregable

Base OMOP propia (documentada, no subida), `consultas_omop.sql` comentado,
el diagrama ER, y un `reporte_calidad.md` con: porcentajes de no mapeados,
comparación estándar/origen, el efecto de `observation_period` y la
comparación con la base de referencia.

---

## Criterios de evaluación

- [ ] La conversión está documentada y es reproducible
- [ ] Los vocabularios están cargados y se reporta cuántos conceptos hay
- [ ] El diagrama ER se comparó con la especificación oficial
- [ ] El porcentaje de `concept_id = 0` se reporta **por dominio**, con diagnóstico
- [ ] Ninguna consulta muestra `concept_id` sin su `concept_name`
- [ ] Toda consulta epidemiológica usa `count(DISTINCT person_id)`
- [ ] El efecto de `observation_period` está cuantificado
- [ ] La diferencia entre conteo estándar y por origen está **explicada**
- [ ] Los hallazgos de ATHENA están documentados

---

## Si te atoras

- **ETL-Synthea falla:** revisa la versión de Synthea. El paquete suele ir un
  paso atrás respecto a la última versión del generador.
- **`CONCEPT` está vacía:** no cargaste los vocabularios. Sin ellos, el CDM
  es un esquema sin significado.
- **Todo mapea a 0:** el ETL no encontró la tabla de vocabularios al correr.
  Revisa el orden: primero vocabularios, después la conversión.
- **La descarga de ATHENA no llega:** puede tardar horas y llega por correo.
  Por eso la actividad 3 va temprano.
- **Broadsea en Mac ARM va lentísimo:** es esperado. Ver la nota de
  `docs/proyecto-final.md`.
- **Mis conteos no cuadran con los de Synthea:** normal. El ETL descarta
  registros que no puede mapear. Cuantifícalo — es la actividad 5.

## Estructura sugerida

```text
s12-omop-cdm-introduccion/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/
```
