# Material complementario — Sesión 26

**Del Modelo al Servicio: Desplegar, Vigilar y Responder**
Bloque V — Machine Learning clínico · cierre del bloque

> Todos los enlaces de esta página se verificaron al preparar el semestre
> 2027-1. La sección de regulación es la que envejece más rápido: **verifica
> las fechas antes de citarlas** en una tesis o en un protocolo.

---

## 1. Serializar y empaquetar

- **[Model persistence — documentación de scikit-learn](https://scikit-learn.org/stable/model_persistence.html)**
  La referencia corta y definitiva. Trae la tabla comparativa de ONNX,
  `skops.io`, `pickle`, `joblib` y `cloudpickle` con los pros y los riesgos de
  cada uno, y el árbol de decisión para elegir. **Léela completa**: son diez
  minutos y resuelve el 90 % de las dudas del laboratorio.

  Lo que conviene no olvidar de ahí: *no hay forma soportada de cargar un modelo
  entrenado con otra versión de scikit-learn*, y la lista de metadatos que
  recomiendan guardar junto al modelo (referencia inmutable a los datos de
  entrenamiento, código fuente, versiones de las dependencias y la métrica de
  validación cruzada obtenida).

- **[skops — persistencia segura](https://skops.readthedocs.io/en/stable/persistence.html)**
  La alternativa a `pickle` cuando el modelo viene de fuera. `get_untrusted_types()`
  es la función que usarás en la actividad 5.

- **[sklearn-onnx](https://onnx.ai/sklearn-onnx/)**
  Para convertir a ONNX. Útil también para descubrir qué **no** se puede
  convertir: no todos los estimadores están soportados.

- **[Adrin Jalali — *Let's exploit pickle, and skops to the rescue!*](https://www.youtube.com/watch?v=9w_H5OSTO9A)** (PyData Amsterdam 2023)
  Si la diapositiva sobre ejecución de código arbitrario te pareció alarmista,
  esta charla lo demuestra en vivo.

---

## 2. Deriva y vigilancia

- **Finlayson SG, Subbaswamy A, Singh K, et al.** *The Clinician and Dataset
  Shift in Artificial Intelligence.* **N Engl J Med** 2021;385(3):283-286.
  [doi:10.1056/NEJMc2104626](https://doi.org/10.1056/NEJMc2104626)

  Tres páginas. La taxonomía de *dataset shift* escrita para clínicos, con
  ejemplos reales de cambios de proceso hospitalario que rompieron modelos
  desplegados. Es la lectura obligatoria de esta sesión.

- **Wong A, Otles E, Donnelly JP, et al.** *External Validation of a Widely
  Implemented Proprietary Sepsis Prediction Model in Hospitalized Patients.*
  **JAMA Intern Med** 2021;181(8):1065-1070.
  [Texto completo](https://jamanetwork.com/journals/jamainternalmedicine/fullarticle/2781307)

  El caso de la sección 4. Al leerlo, fíjate específicamente en dos cosas que
  casi nunca se citan: el **número necesario a evaluar** según el horizonte
  temporal (de 8 a 109 pacientes), y el análisis de sensibilidad donde el AUROC
  sube de 0.63 a 0.80 al incluir las puntuaciones generadas hasta tres horas
  **después** del inicio de la sepsis.

  Acompáñalo del editorial del mismo número: Habib AR, Lin AL, Grant RW,
  *The Epic Sepsis Model Falls Short—The Importance of External Validation*,
  JAMA Intern Med 2021;181(8):1040-1041.

### Sobre el índice de estabilidad poblacional (PSI)

El PSI no tiene un artículo fundacional en la literatura biomédica: viene del
*credit scoring* y se adoptó por costumbre. Los cortes convencionales
—**< 0.10** estable, **0.10–0.25** revisar, **> 0.25** actuar— son heurísticos,
no resultados estadísticos.

> Dicho de otro modo: úsalos como alarma, no como prueba. Si vas a reportar
> deriva en un artículo, acompaña el PSI de algo con distribución conocida
> (Kolmogórov–Smirnov, por ejemplo) o de una comparación de la métrica clínica.

---

## 3. Llevarlo a producción

### Un pipeline real, documentado de principio a fin

- **Sendak MP, Ratliff W, Sarro D, et al.** *Real-World Integration of a Sepsis
  Deep Learning Technology Into Routine Clinical Care: Implementation Study.*
  **JMIR Med Inform** 2020;8(7):e15182.
  [Texto completo](https://medinform.jmir.org/2020/7/e15182/)

  El artículo de la sección 5. Es raro porque cuenta la **ingeniería**, no sólo
  el modelo: cada cuánto se jalan los datos de Epic, cada cuánto puntúa el
  modelo, qué dos tableros de vigilancia construyeron, cómo fijaron el umbral a
  partir de cuántas llamadas puede hacer un enfermero en una hora, y por qué el
  modelo que desplegaron no es el del artículo original.

  Léelo completo si tu proyecto final va a tocar a un paciente. La tabla 1
  (las ocho etapas) sirve como lista de verificación de lo que te falta.

- *Integrating a Machine Learning System Into Clinical Workflows: Qualitative
  Study.* **J Med Internet Res** 2020;22(11):e22421.
  [Texto completo](https://www.jmir.org/2020/11/e22421/)

  El mismo despliegue de Duke visto desde el personal que lo usó. Si el
  anterior es cómo se construye, éste es por qué se adopta o no: utilidad
  percibida y confianza, los procesos alrededor del modelo, y el efecto sobre
  la carga de trabajo.

### Registro y versionado de modelos

- **[MLflow Model Registry](https://mlflow.org/docs/latest/ml/model-registry/)**
  La referencia de los conceptos que usamos en clase: modelo registrado,
  **versión** (se incrementa sola), **URI** (`models:/nombre/2`), **alias**
  (`models:/nombre@champion`, el apuntador movible), etiquetas y linaje.

  Lo que hay que entender de aquí: el alias es lo que te permite promover y
  revertir sin tocar el código del servicio.

- **[Amazon SageMaker AI — Model Registry](https://docs.aws.amazon.com/sagemaker/latest/dg/model-registry.html)**
  El equivalente gestionado: grupos de modelos, versiones, metadatos, estado de
  **aprobación**, linaje e integración con las model cards y con CI/CD.
  Encaja directo con lo que vieron en las sesiones 19 a 21.

### Actualizar sin apagar

- **[SageMaker AI — Deployment guardrails](https://docs.aws.amazon.com/sagemaker/latest/dg/deployment-guardrails.html)**
  Despliegues azul/verde con tres modos de traslado de tráfico (*all at once*,
  **canario**, lineal), despliegues *rolling*, **periodo de reposo** vigilado
  por alarmas de CloudWatch y **reversión automática**.

  Aunque no uses AWS, lee esta página por el vocabulario: son los nombres que
  vas a encontrar en cualquier plataforma seria.

### Servir el modelo

- **[MLflow — servidor de inferencia local](https://mlflow.org/docs/latest/ml/deployment/deploy-model-locally/)**
  Un comando (`mlflow models serve`) levanta `/invocations`, `/ping`, `/health`
  y `/version`. Por debajo usa **FastAPI**, así que es literalmente lo de la
  sesión 9 hecho por otros.

  Lee la sección de formatos de entrada: ahí se ve el límite de la herramienta.
  Acepta CSV o JSON con forma de dataframe y **convierte los tipos al esquema
  del modelo en silencio**; nada de eso valida que un eGFR sea fisiológicamente
  posible. Esa capa la sigues escribiendo tú.

  La misma página trae el modo lote (`mlflow models predict -i entrada.csv -o
  salida.csv`) y la construcción de la imagen Docker.

### Alternativas

| Herramienta | Para qué |
|---|---|
| [BentoML](https://docs.bentoml.com/) | empaquetar y servir modelos como servicios |
| [KServe](https://kserve.github.io/website/) | servir sobre Kubernetes, con *canary* nativo |
| [Vertex AI](https://cloud.google.com/vertex-ai/docs) · [Azure ML](https://learn.microsoft.com/azure/machine-learning/) | los equivalentes de SageMaker |

> Y la opción que no aparece en los catálogos: **FastAPI dentro de un
> contenedor, en una instancia**. Para un modelo, con un equipo, es suficiente y
> es defendible. La plataforma se paga cuando hay varios modelos y varios
> equipos.

---

## 4. Regulación

### Estados Unidos

- **[Marketing Submission Recommendations for a Predetermined Change Control
  Plan for Artificial Intelligence-Enabled Device Software Functions](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/marketing-submission-recommendations-predetermined-change-control-plan-artificial-intelligence)**
  Guía **final**, agosto de 2025. Expediente FDA-2022-D-2628.
  Aplica a las vías 510(k), De Novo y PMA.

  La idea central, que vale para cualquier jurisdicción: en vez de autorizar el
  modelo, se autoriza **el procedimiento de cambio** — qué modificaciones harás,
  con qué método las validarás y cómo evaluarás su impacto.

### Unión Europea

- **[Reglamento (UE) 2026/1744](https://eur-lex.europa.eu/legal-content/ES/TXT/?uri=OJ:L_202601744)**
  («Ómnibus digital sobre IA»), de 8 de julio de 2026, DO L de 24.7.2026.
  Modifica el Reglamento (UE) 2024/1689 (Ley de IA) y **aplaza** la aplicación
  de las obligaciones de alto riesgo:

  | | Nueva fecha |
  |---|---|
  | Art. 6(2) y Anexo III | 2 de diciembre de 2027 |
  | **Art. 6(1) y Anexo I** — IA dentro de un producto ya regulado | **2 de agosto de 2028** |

  **Un modelo clínico cae en el Anexo I**, no en el Anexo III, porque llega
  regulado por el MDR. Es el error de lectura más frecuente.

  El mismo reglamento encarga a la Comisión publicar, antes del **2 de
  septiembre de 2027**, la guía y la plantilla del **plan de vigilancia
  poscomercialización**: es decir, la sección 4 de esta sesión convertida en
  obligación legal.

- **[AI Act Explorer — Ómnibus digital](https://artificialintelligenceact.eu/ai-act-explorer/digital-omnibus/)**
  Lectura más cómoda que el DOUE, con el texto consolidado artículo por
  artículo. No es fuente oficial: para citar, usa EUR-Lex.

### México

- **[COFEPRIS — Listados de registros de dispositivos médicos e información
  relacionada](https://www.gob.mx/cofepris/documentos/registros-dispositivos-medicos)**
  Desde aquí se descarga la **[Guía para la obtención del registro sanitario de
  dispositivos médicos Clase I, II, III y Software como Dispositivo
  Médico](https://www.gob.mx/cms/uploads/attachment/file/876069/GUIA_PARA_LA_OBTENCION_DEL_REGISTRO_SANITARIO_DE_DISPOSITIVOS_MEDICOS_CLASE_I-II-III_Y_SOFTWARE_COMO_DISPOSITIVO_MEDICO.pdf)**,
  que trae las listas de verificación específicas de ScDM por clase de riesgo.

  La definición de software como dispositivo médico viene del **Suplemento para
  Dispositivos Médicos de la FEUM**; la clasificación de riesgo, del **artículo
  83 del Reglamento de Insumos para la Salud**.

**Lo que a la fecha de preparación de este curso NO existe en México:**

- guía específica para dispositivos médicos con inteligencia artificial
- un equivalente al PCCP: no hay vía declarada para un modelo que se reentrena
- criterios publicados sobre validación externa o vigilancia poscomercialización

> Esto no significa que no haya obligaciones: significa que la carga de
> demostrar que el modelo es seguro recae casi por completo en el equipo que lo
> despliega. Verifica el estado actual en gob.mx antes de citarlo.

---

## 5. Ética en producción

- **Dratsch T, Chen X, Rezazade Mehrizi M, et al.** *Automation Bias in
  Mammography: The Impact of Artificial Intelligence BI-RADS Suggestions on
  Reader Performance.* **Radiology** 2023;307(4):e222176.
  [doi:10.1148/radiol.222176](https://doi.org/10.1148/radiol.222176)

  Los datos de la figura 07. Lee también la limitación que los autores declaran:
  la IA era **simulada**, así que el estudio mide el sesgo hacia una sugerencia
  atribuida a una IA, no el desempeño de un sistema real. Eso no debilita el
  hallazgo para nuestro propósito — lo que se mide es cómo reacciona el lector
  humano — pero es parte de la lectura honesta del artículo.

- **Mitchell M, Wu S, Zaldivar A, et al.** *Model Cards for Model Reporting.*
  FAT\* '19, pp. 220-229.
  [doi:10.1145/3287560.3287596](https://doi.org/10.1145/3287560.3287596) ·
  [arXiv:1810.03993](https://arxiv.org/abs/1810.03993)

  El artículo que inventó la *model card*. Corto, con plantilla incluida. El
  apartado que más gente omite —y el que más importa en clínica— es el de
  desempeño desagregado por subgrupo.

- **Gebru T, Morgenstern J, Vecchione B, et al.** *Datasheets for Datasets.*
  [arXiv:1803.09010](https://arxiv.org/abs/1803.09010)

  El equivalente para el conjunto de datos. Si la *model card* documenta el
  modelo, la *datasheet* documenta de dónde salieron los datos y con qué
  consentimiento.

> Recuerda que el marco de protección de datos ya se vio en la sesión 1. Lo
> único que agrega el despliegue: **la predicción también es un dato personal
> sensible**, y el registro de auditoría que te exige el regulador es, él
> mismo, una base de datos de salud.

---

## 6. Para ir más lejos

- **Rajkomar A, Dean J, Kohane I.** *Machine Learning in Medicine.*
  **N Engl J Med** 2019;380(14):1347-1358.
  [doi:10.1056/NEJMra1814259](https://doi.org/10.1056/NEJMra1814259)
  Panorámica general; el apartado de implementación sigue vigente.

- **TRIPOD+AI** — ya lo usaste en el laboratorio 25. Al desplegar, las secciones
  de validación externa y de monitoreo dejan de ser opcionales.

- **Vasey B, Nagendran M, et al.** (DECIDE-AI expert group) *Reporting guideline for the
  early-stage clinical evaluation of decision support systems driven by
  artificial intelligence: DECIDE-AI.* **Nat Med** 2022;28(5):924-933.
  [doi:10.1038/s41591-022-01772-9](https://doi.org/10.1038/s41591-022-01772-9)

  Cubre justo el hueco entre «el modelo valida bien» y «el ensayo clínico»: el
  periodo en que el sistema ya está frente a un clínico pero todavía no se sabe
  si ayuda. Si tu proyecto final va a desplegarse de verdad, su checklist es el
  mapa de lo que te falta.

---

## Cierre del bloque V

De la sesión 22 a la 26 recorrimos el ciclo completo: entrenar, construir
variables, comparar algoritmos, evaluar para una decisión clínica, y desplegar.

Si te quedas con una sola idea del bloque, que sea ésta: **el modelo es la parte
fácil**. Las variables, el umbral, la calibración, la vigilancia y la pregunta
de quién lo apaga son las que determinan si algo de esto le sirve a un paciente.
