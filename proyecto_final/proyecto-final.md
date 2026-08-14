# Proyecto final

## Qué se entrega

Un repositorio de GitHub público (o privado con acceso al profesor) que resuelva de principio a fin
una pregunta con datos clínicos, usando las herramientas del curso.

No es un notebook. Es un proyecto: código, pruebas, documentación, entorno reproducible.

## Modalidades

Elige una. Todas requieren SQL sobre OMOP y control de versiones; se diferencian en el énfasis.

### A. Estudio de caracterización / epidemiológico
Define una cohorte, caracterízala y responde una pregunta descriptiva o de asociación.
**Énfasis:** bloques II y III (SQL, OMOP, vocabularios, cohortes).
**Extra:** tabla de atrición, análisis de sensibilidad de la definición.

### B. Modelo predictivo clínico
Predice un desenlace a partir de datos previos a una fecha índice.
**Énfasis:** bloques III y V (cohortes, features, ML, evaluación).
**Extra:** calibración, decision curve analysis, análisis por subgrupos, Model Card.

### C. Pipeline de datos en la nube
Ingesta, transformación y publicación de datos clínicos con infraestructura reproducible.
**Énfasis:** bloques II y IV (Docker, APIs, S3, EC2).
**Extra:** CI/CD, monitoreo, estimación de costos.

### D. Aplicación de IA generativa en biomedicina
NER clínico, NL2SQL sobre OMOP, o RAG sobre literatura/protocolos.
**Énfasis:** bloque VI.
**Extra:** evaluación cuantitativa con set etiquetado propio, política de uso.

> Puedes proponer otra modalidad. Habla con el profesor antes de la sesión 10.

## Requisitos mínimos (todas las modalidades)

- [ ] Repositorio con historial de commits real (no un solo commit al final)
- [ ] `README.md` que permita a un tercero reproducir el trabajo
- [ ] Entorno containerizado (`Dockerfile` o `compose.yml`)
- [ ] Al menos una definición de cohorte en SQL sobre OMOP, documentada
- [ ] Pruebas automáticas con pytest y CI en GitHub Actions
- [ ] Diccionario de datos / documentación de variables
- [ ] Sección de limitaciones escrita honestamente
- [ ] Declaración de uso de asistentes de IA
- [ ] Cero credenciales y cero datos identificables en el repositorio

## De dónde sacar los datos


### Ruta A — Datos sintéticos (recomendada para empezar)

Sin trámites, sin riesgo de privacidad, y suficientes para un proyecto serio.

**[Synthea](https://synthetichealth.github.io/synthea/)** — generador de pacientes sintéticos con
historias clínicas longitudinales coherentes (diagnósticos, medicamentos, laboratorios, encuentros).
Tú decides cuántos pacientes, qué estado y qué módulos de enfermedad.

```bash
# Genera 5000 pacientes sintéticos
java -jar synthea-with-dependencies.jar -p 5000 Massachusetts
```

- **[ETL-Synthea](https://github.com/OHDSI/ETL-Synthea)** — paquete de OHDSI que carga la salida
  de Synthea directamente a un esquema OMOP CDM. Es la vía más limpia para tener tu propia
  base OMOP con el volumen que quieras.
- **[Eunomia](https://github.com/OHDSI/Eunomia)** — base OMOP de juguete en SQLite. Diminuta,
  ideal para prototipar consultas antes de correrlas sobre algo grande.
- **[CMS SynPUF en OMOP](https://github.com/OHDSI/ETL-CMS)** — datos sintéticos derivados de
  Medicare, ya convertidos a OMOP. Más realistas en estructura de claims que Synthea.

---

### Ruta A+ — Levanta el stack completo de OHDSI con Broadsea

**[OHDSI Broadsea](https://github.com/OHDSI/Broadsea)** despliega con Docker Compose toda la
infraestructura que usan las farmacéuticas: ATLAS, WebAPI, HADES/RStudio y una base Postgres
con OMOP CDM y vocabularios ya cargados.

```bash
git clone https://github.com/OHDSI/Broadsea.git
cd Broadsea
docker compose --profile default up -d
# ATLAS queda en http://localhost/atlas
```

Viene con [Broadsea-AtlasDB](https://github.com/OHDSI/Broadsea-Atlasdb), un CDM de demostración
preconfigurado, así que puedes definir cohortes en ATLAS el mismo día.

> **Si tienes Mac con Apple Silicon (M1–M4):** hay que fijar `DOCKER_ARCH=linux/arm64` en el
> `.env`, y aun así algunos servicios corren emulados y van lentos. Cuenta con una tarde de
> configuración. La [documentación oficial](http://ohdsi.github.io/Broadsea/) lo detalla.

Broadsea es una opción entre varias: para la mayoría de los laboratorios basta con DuckDB y
tus datos de Synthea. Pero si tu proyecto es de la modalidad A o B, tener ATLAS te ahorra
mucho trabajo manual — y saber levantarlo es algo que se pregunta en entrevistas.

---

### Ruta B — Datos reales de pacientes: MIMIC-IV Demo

**[MIMIC-IV Clinical Database Demo](https://physionet.org/content/mimic-iv-demo/)** — 100 pacientes
reales de cuidados intensivos del Beth Israel Deaconess Medical Center. **Sin registro, sin
credencial, descarga directa.**

Es un subconjunto del dataset clínico más usado del mundo en investigación. Tiene la misma
estructura que MIMIC-IV completo —admisiones, diagnósticos, laboratorios, medicamentos, signos
vitales de UCI— pero no incluye las notas clínicas libres.

Cien pacientes bastan para construir un proyecto sólido: la dificultad de MIMIC no está en el
volumen, está en entender el modelo de datos y en definir bien la cohorte.

Existen variantes del demo, también abiertas, según lo que necesite tu proyecto:

- **[MIMIC-IV Demo on FHIR](https://physionet.org/content/mimic-iv-fhir-demo/)** — los mismos
  pacientes en formato FHIR, útil si tu proyecto toca interoperabilidad (sesión 8)
- **[MIMIC-IV-ED Demo](https://physionet.org/content/mimic-iv-ed-demo/)** — datos del servicio
  de urgencias

### Ruta C — Repositorios de datasets

**[Hugging Face Datasets](https://huggingface.co/datasets)** — miles de datasets, muchos
biomédicos. Filtra por tarea y por licencia.

- **[BigBIO](https://huggingface.co/bigbio)** — colección que unifica el esquema de decenas de
  recursos de NLP biomédico. Muy útil para las sesiones 28 y 29:
  [MedQA](https://huggingface.co/datasets/bigbio/med_qa) (preguntas de exámenes médicos),
  [MedNLI](https://huggingface.co/datasets/bigbio/mednli) (inferencia sobre historias clínicas),
  [MedDialog](https://huggingface.co/datasets/bigbio/meddialog) (260 000 diálogos médico–paciente).

> **Revisa la licencia y la procedencia antes de usar nada de Hugging Face.** Cualquiera puede
> subir un dataset. Hay recursos excelentes junto a otros sin licencia clara, mal documentados o
> derivados de fuentes con restricciones. Si no puedes decir de dónde salió un dato, no lo uses
> en tu proyecto.

Otros repositorios:

- **[PhysioNet](https://physionet.org/about/database/)** — el catálogo completo, con su nivel
  de acceso indicado en cada entrada
- **[Registry of Open Data on AWS — Life Sciences](https://registry.opendata.aws/tag/life-sciences/)** —
  1000 Genomes, GNOMAD, TCGA. Se leen directo desde S3 (sesión 20)
- **[GDC Data Portal](https://portal.gdc.cancer.gov/)** — TCGA y otros datos oncológicos, con
  un nivel abierto sin trámite
- **[Kaggle — Datasets](https://www.kaggle.com/datasets)** — útil para
  practicar; verifica siempre la procedencia

---

### Ruta D — Datos abiertos de México

Poco explotados y con valor local evidente. Si tu proyecto usa datos mexicanos, tiene mérito
adicional: casi nadie lo hace.

- **[DGIS — Egresos hospitalarios en datos abiertos](http://www.dgis.salud.gob.mx/contenidos/basesdedatos/da_egresoshosp_gobmx.html)** —
  egresos hospitalarios, urgencias y recursos en salud. Codificados en CIE-10, lo que los
  hace mapeables a OMOP (sesión 14)
- **[INEGI — Estadísticas de defunciones registradas](https://www.inegi.org.mx/programas/edr/)** —
  todas las defunciones del país con causa codificada en CIE-10. Es un registro exhaustivo,
  no una muestra
- **[ENSANUT](https://ensanut.insp.mx/)** — Encuesta Nacional de Salud y Nutrición. Ojo: es
  una **encuesta por muestreo**, no un registro, y la levanta el Instituto Nacional de Salud
  Pública (el INEGI colaboró en la edición 2018)
- **[Plataforma Nacional de Datos Abiertos](https://www.datos.gob.mx/)** — catálogo federal

---

### Reglas del curso sobre datos

- **Ningún dato identificable de paciente entra al repositorio.** Nunca, por ninguna razón.
- Si tu proyecto usa datos reales de tu laboratorio o de tu institución, mantenlos fuera del
  repositorio y documenta en el README cómo se accede a ellos.
- Si un dataset trae términos de uso o licencia, léelos y respétalos. Tú respondes por eso.
- Declara siempre la fuente, la versión y la fecha de descarga: sin eso tu trabajo no es
  reproducible.

## Usa tu propio dominio

El mejor proyecto es el que se conecta con tu tesis. Si trabajas en oncología, define una cohorte
oncológica. Si trabajas en metabolismo, predice un desenlace metabólico. El curso da las
herramientas; la pregunta la pones tú.

Si tu tesis no se presta a datos clínicos observacionales, usa los datos sintéticos del curso
y elige una pregunta que te interese de verdad.

## Estructura sugerida

```
mi-proyecto/
├── README.md
├── Dockerfile / compose.yml
├── pyproject.toml
├── .github/workflows/ci.yml
├── sql/
│   ├── 01_concept_sets.sql
│   ├── 02_cohorte.sql
│   └── 03_features.sql
├── src/miproyecto/
├── tests/
├── notebooks/          # exploración, no lógica de producción
├── docs/
│   ├── protocolo.md    # pregunta, población, método
│   ├── features.md     # diccionario de datos
│   └── MODEL_CARD.md   # si aplica
└── figuras/
```

## Calendario

| Sesión | Hito |
|---|---|
| 10 | Propuesta de 1 página: pregunta, modalidad, datos, entregable esperado |
| 18 | Cohorte definida, implementada y con tabla de atrición |
| 24 | Avance intermedio: 15 min de revisión con el profesor |
| 30 | Entrega del repositorio final |
| 31 | Presentación de 12 min + 5 de preguntas |

## Consejo

Un proyecto pequeño y bien terminado vale mucho más que uno ambicioso a medias — tanto en la
calificación como en una entrevista de trabajo. Reduce el alcance antes de reducir la calidad.
