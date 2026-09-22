# Laboratorio 13 — Exposición a fármacos y laboratorios

**Sesión 13:** OMOP CDM: Drug Exposure, Measurement y Tablas Derivadas
**Bloque:** III — SQL y datos clínicos estandarizados

## Objetivo

Construir métricas **farmacoepidemiológicas** sobre tu base OMOP y producir un
reporte de calidad de datos que puedas enseñar sin vergüenza.

Al terminar tendrás lo que necesitas para definir exposición y desenlaces en la
sesión 17, y las variables de laboratorio de la sesión 23.

---

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**.

**Necesitarás:** `pandas duckdb jupysql matplotlib`

**Punto de partida:** tu base OMOP del laboratorio 12, con vocabularios cargados.

> Si tu conversión dejó `DRUG_EXPOSURE` o `MEASUREMENT` muy pobres, dilo y
> trabaja con lo que haya. Documentar la limitación **es** parte del ejercicio.

---

## Actividades

### 1. ¿Qué tipo de exposición tienes?

Antes de cualquier análisis, averigua con qué estás trabajando:

```text
SELECT drug_type_concept_id, ... GROUP BY ...
```

**Entrega:** la distribución por tipo, con el nombre legible de cada uno, y una
frase: ¿tus datos son prescripciones, dispensaciones o administraciones?
¿Qué implica eso para cualquier conclusión sobre exposición?

---

### 2. Caracterizar `DRUG_EXPOSURE`

- Top 20 de ingredientes, con nombre legible y número de **pacientes distintos**
- Distribución de `days_supply`
- **Porcentaje de filas sin `drug_exposure_end_date`**, o con `end_date = start_date`
- Porcentaje con `drug_concept_id = 0`

**Entrega:** la tabla y tu diagnóstico sobre si esta base sirve para estudiar
exposición.

---

### 3. Buscar por ingrediente, no por producto

Cuenta los pacientes expuestos a un fármaco de dos formas:

1. Filtrando por el `drug_concept_id` exacto del ingrediente
2. Usando `CONCEPT_ANCESTOR` para incluir **todos sus productos descendientes**

**Entrega:** ambos números y la diferencia. Va a ser grande, y explica por qué.

> Ésta es la razón de ser de la sesión 16. Hoy la usas; allá la entenderás
> por dentro.

---

### 4. Construir `DRUG_ERA` a mano

Con el patrón de *gaps and islands* de la sesión 11, construye las eras de
tratamiento de un ingrediente frecuente, con gap de 30 días.

Si tu base trae la tabla `DRUG_ERA` derivada, **compárala con la tuya**:
¿mismo número de eras? ¿mismas fechas? Explica cualquier diferencia.

Si no la trae, genérala tú y déjala en tu esquema `results`.

---

### 5. Adherencia: proporción de días cubiertos

Calcula el **PDC** de los pacientes expuestos a ese ingrediente durante un año
de seguimiento:

$$\text{PDC} = \frac{\text{días con fármaco disponible}}{\text{días del periodo}}$$

**Entrega:** la distribución del PDC, el porcentaje de pacientes con PDC ≥ 0.8
(el umbral convencional de «adherente»), y dos renglones sobre qué supuestos
tuviste que hacer.

> Investiga la diferencia entre PDC y MPR y di cuál usaste y por qué.

---

### 6. Caracterizar `MEASUREMENT`

- Top 15 de analitos por número de mediciones y de pacientes
- Para uno que elijas: distribución de `unit_concept_id`
- Porcentaje de mediciones con `value_as_number` nulo
- Porcentaje con `operator_concept_id` no nulo (valores censurados)

**Entrega:** la tabla y una nota sobre qué harías con los valores censurados.

---

### 7. Normalizar unidades

Toma un analito con más de una unidad (o simula el caso si tu base tiene sólo
una) y **normalízalo a una unidad canónica**.

Requisitos:

- Documenta el factor o la fórmula, **con su fuente**
- Conserva el valor original en otra columna
- Reporta cuántas filas convertiste

**Entrega:** el antes y después de la distribución, como la figura de la sesión.

---

### 8. Valores implausibles

Define rangos plausibles para tres analitos, **citando una fuente** (artículo,
guía de laboratorio, MDCalc). No los inventes.

Después:

- ¿Cuántos valores quedan fuera?
- ¿Hay valores que se repiten **exactamente** y son imposibles? Son centinelas
  (sesión 3), no errores de captura
- ¿Qué haces con cada grupo: excluir, marcar o convertir a nulo?

**Entrega:** la tabla de criterios con su fuente, y los conteos.

---

### 9. `MEASUREMENT` contra `OBSERVATION` en TU base

Busca tres hechos clínicos (peso, tabaquismo y uno que elijas) y averigua en
cuál de las dos tablas los puso tu ETL.

**Entrega:** dónde quedó cada uno y si coincide con lo que dicen las
convenciones de THEMIS.

---

### 10. El último valor antes del índice

Define una fecha índice por paciente y obtén el valor de un analito **más
cercano al índice**, dentro de ±90 días, usando el patrón de la sesión 11.

Reporta: para cuántos pacientes hay valor basal y para cuántos no.
Ese porcentaje es el que va a limitar tu cohorte en la sesión 17.

---

### Bono

- Ejecuta [Achilles](https://github.com/OHDSI/Achilles) o el
  [Data Quality Dashboard](https://ohdsi.github.io/DataQualityDashboard/)
  sobre tu base y compara sus hallazgos con los tuyos
- Construye `CONDITION_ERA` con el mismo patrón

---

## Entregable

`farmacoepi.sql` con las consultas comentadas, un notebook con las
distribuciones y un `reporte_calidad.md` que reúna: tipo de exposición,
completitud de fechas, unidades encontradas, valores implausibles con su
criterio citado, y la limitación principal de tu base.

---

## Criterios de evaluación

- [ ] Se identifica el tipo de exposición y se explica qué implica
- [ ] La búsqueda por ingrediente usa `CONCEPT_ANCESTOR` y se compara con la directa
- [ ] Las eras construidas a mano se comparan con la tabla derivada (o se justifica su ausencia)
- [ ] El PDC declara sus supuestos y se distingue de MPR
- [ ] Toda conversión de unidades cita su fuente y conserva el original
- [ ] Los rangos plausibles están **citados**, no inventados
- [ ] Se distinguen implausibles, centinelas y extremos reales
- [ ] Ninguna consulta muestra `concept_id` sin `concept_name`
- [ ] El reporte declara la limitación principal de la base

---

## Si te atoras

- **`DRUG_ERA` está vacía:** muchas conversiones no la generan. Constrúyela tú
  (actividad 4); es el ejercicio.
- **Todos los `days_supply` son nulos:** tu base es de administraciones o el
  ETL no lo trajo. Documéntalo y usa fechas.
- **Buscar por ingrediente no devuelve nada:** revisa que `CONCEPT_ANCESTOR`
  esté cargada. Sin ella no hay jerarquía.
- **Sólo hay una unidad por analito:** Synthea es más limpio que la realidad.
  Simula el caso mezclando una conversión y trabaja sobre eso.
- **El PDC sale mayor que 1:** tienes surtidos solapados. Eso es justamente lo
  que distingue PDC de MPR.

## Estructura sugerida

```text
s13-omop-drug-measurement/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/
```
