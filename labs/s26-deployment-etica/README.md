# Laboratorio 26 — Del modelo al servicio

**Sesión 26:** Del Modelo al Servicio: Desplegar, Vigilar y Responder
**Bloque:** V — Machine Learning clínico · **cierre del bloque**

## Objetivo

Convertir el modelo de la sesión 25 en algo que **otra persona** pueda correr,
auditar y apagar. No «lo subí a un servidor», sino: alguien que no estuvo en tu
proyecto obtiene los mismos números, entiende para qué sirve y sabe cuándo
dejar de usarlo.

Aquí se juntan el paquete de la sesión 5, la imagen de la 6, la API de la 9 y
todo el bloque V.

---

## Antes de empezar

Trabaja en **tu propio equipo**: necesitas terminal y, en la parte C, Docker.

**Necesitarás:** `scikit-learn joblib skops fastapi uvicorn pydantic mlflow`
· para pruebas: `pytest httpx` · opcional: `skl2onnx onnxruntime`

**Punto de partida:** el pipeline ajustado de la sesión 24, el calibrador y el
umbral $p_t$ que fijaste en la 25, y el conjunto de prueba **sin tocar**.

> **Primera decisión, antes de escribir una línea:** ¿dónde se va a consumir la
> predicción — en una consulta, en una lista nocturna, en una alerta? Escríbelo.
> De esa respuesta salen la latencia aceptable, el umbral y el plan de apagado.

Material complementario: [`recursos/s26-deployment-etica.md`](../../recursos/s26-deployment-etica.md)

---

## Parte A — El artefacto

### 1. Inventario de lo que falta

Abre tu `.pkl` o `.joblib` de la sesión 25 y escribe, en una tabla, qué contiene
hoy y qué **no**: ¿está el calibrador? ¿el umbral? ¿los nombres y el orden de las
columnas? ¿las unidades? ¿la versión de scikit-learn con la que se entrenó?

**Entrega:** la tabla, con una columna «dónde vive hoy» (muy probablemente:
«en mi cabeza» o «en la celda 14 del notebook»).

---

### 2. Construir el artefacto completo

Produce un directorio versionado que contenga, como mínimo:

| Archivo | Qué guarda |
|---|---|
| el modelo serializado | el pipeline **completo**, calibrador incluido |
| `MODEL_META.json` | versión del modelo, umbral, fecha, métricas esperadas, versiones de las dependencias, hash del commit |
| `ESQUEMA.json` | nombre, tipo, unidad (UCUM) y rango válido de cada variable de entrada |
| `requirements.txt` | pineado, no `>=` |

> **Trampa:** el calibrador de la sesión 25 se ajustó en un conjunto distinto al
> de entrenamiento. Si lo guardas por separado del pipeline, tarde o temprano
> alguien va a cargar uno sin el otro. Decide **a propósito** si van juntos o
> separados, y escribe por qué.

**Entrega:** el directorio, y tres líneas justificando esa decisión.

---

### 3. La prueba de fuego

Intercambia tu artefacto con un compañero, **sin explicarle nada**. Cada quien
corre la predicción del otro sobre los mismos diez pacientes de un CSV que
ustedes acuerden.

**Entrega:** las dos tablas de diez predicciones, lado a lado, y la lista de
todo lo que tu compañero tuvo que preguntarte. Esa lista es el inventario
exacto de lo que le falta a tu artefacto.

> Si los números no coinciden hasta el tercer decimal, **no cierres la
> actividad**: encuentra por qué y arréglalo. Esa diferencia es el laboratorio
> entero.

---

## Parte B — Guardarlo sin que se rompa

### 4. Medir, no suponer

Guarda tu mismo pipeline en al menos tres formatos (`joblib`, `joblib` con
`compress=3`, `skops.io`) y mide **tamaño en disco** y **tiempo de carga**
(mediana de ≥5 repeticiones, no una sola medición).

**Entrega:** tabla de resultados + una línea diciendo qué formato elegiste para
tu despliegue y por qué.

> **Opcional:** si vas a servir desde un entorno sin Python, prueba también
> ONNX con `skl2onnx`. No todos los estimadores de scikit-learn tienen
> conversor, así que puede que el tuyo no esté soportado — si eso pasa, anota
> el error y sigue adelante; no es parte de la calificación.

---

### 5. Romper la carga a propósito

Usa `skops.io.get_untrusted_types()` sobre tu artefacto y anota qué tipos
reporta. Luego, provoca el `InconsistentVersionWarning`: captúralo como error y
recupera con qué versión se entrenó el modelo.

**Entrega:** la lista de tipos no confiables de **tu** modelo, y la salida del
warning capturado.

> Lo primero es seguridad; lo segundo es reproducibilidad. Son dos razones
> distintas para pinear versiones y vale la pena no confundirlas.

---

### 6. Higiene del repositorio

Corre `gitleaks` sobre tu repositorio. Verifica además que no haya datos de
pacientes ni el conjunto de prueba commiteados.

**Entrega:** salida de `gitleaks`. Si aparece algo, **rota la credencial** —
borrar el commit no sirve, el secreto ya salió.

---

## Parte C — Servirlo

### 7. El contrato de entrada

Construye el endpoint `/predict`. El modelo de Pydantic debe declarar **rangos
fisiológicos**, no sólo tipos: un eGFR de 4 000 tiene que rechazarse con un 422,
no producir una predicción.

**Entrega:** el esquema, y tres pruebas que verifiquen el rechazo de valores
imposibles (negativo, fuera de rango, unidad equivocada).

---

### 8. La trampa de la latencia

Implementa el servicio **mal a propósito** (cargando el modelo dentro del
endpoint) y mídelo. Después corrígelo (carga única al arranque) y vuelve a
medir, con al menos 50 peticiones.

**Entrega:** las dos latencias medianas y el factor entre ellas.

---

### 9. Una respuesta que se pueda auditar

La respuesta debe permitir contestar, dentro de seis meses: *¿qué versión del
modelo produjo esta alerta, con qué umbral, y sobre qué datos?*

Diseña el cuerpo de la respuesta y el registro (log) que la acompaña.

> **Trampa:** el registro de predicciones es, él mismo, una base de datos de
> salud. Decide qué guardas de la entrada — ¿los valores? ¿sólo un hash? — y
> justifícalo en una línea.

**Entrega:** ejemplo de respuesta, ejemplo de línea de registro, y la
justificación.

---

### 10. Empaquetar

Dockeriza el servicio. La imagen debe fijar la versión de Python y las
dependencias que tu artefacto exige.

**Entrega:** `Dockerfile` + el comando que levanta el servicio + captura de una
petición exitosa contra el contenedor.

---

## Parte D — El skew

### 11. Reproducir el error que nadie ve

Elige una de tus variables y calcúlala **dos veces**: como lo hiciste al
entrenar (con toda la historia disponible) y como la calcularía el servicio en
el momento de predecir (sin los datos que todavía no habrían llegado).

Pasa ambas versiones por el **mismo** modelo y mide: AUROC, Brier, tasa de
alerta y **sensibilidad al umbral**.

**Entrega:** la tabla de las cuatro métricas antes y después, y una línea sobre
cuál de ellas se dio cuenta primero.

> En la figura de clase, el AUROC casi no se movió (0.910 → 0.888) mientras la
> sensibilidad cayó de 83.8 % a 75.3 %. Si tu AUROC se mueve mucho más que eso,
> revisa si exageraste el retraso.

---

## Parte E — Vigilancia

### 12. Implementar el PSI, con pruebas

Escribe la función que calcula el índice de estabilidad poblacional entre una
distribución de referencia y una actual. **Con `pytest`**, y cubriendo al menos:

- distribuciones idénticas → PSI = 0
- un bin vacío en la actual → no debe dividir entre cero ni devolver `inf`
- la función es asimétrica: `psi(a, b) ≠ psi(b, a)` salvo casos triviales
- los cortes se calculan sobre la **referencia**, no sobre la actual

**Entrega:** la función, las pruebas, y la salida de `pytest`.

> Esta es la actividad con más trampas del laboratorio. La mayoría de las
> implementaciones que circulan en internet fallan el segundo caso.

---

### 13. El reporte de vigilancia

Genera al menos 12 periodos de datos con una deriva que **tú** introduzcas, y
produce un reporte que diga, para cada periodo: PSI por variable, PSI de la
predicción, tasa de alerta y proporción de nulos.

Define los umbrales de alarma **antes** de ver los resultados.

**Entrega:** el reporte (tabla o gráfica) + los umbrales que fijaste + el
periodo en que tu alarma habría sonado.

> **Pregunta a contestar en el reporte:** ¿tu deriva es de datos o de concepto?
> ¿Se arreglaría recalibrando, o hay que reentrenar?

---

## Parte F — Registro, promoción y despliegue

### 14. Registrar el modelo, no guardarlo

Levanta un registro local (`mlflow server` o el backend de archivos sirve) y
registra **al menos dos versiones** de tu modelo: la de la sesión 24 y la
recalibrada de la 25.

Cada versión debe quedar ligada a la corrida que la produjo, con sus métricas y
sus parámetros. Después, marca con una etiqueta la que pasó tus compuertas.

**Entrega:** captura o salida del registro mostrando las dos versiones, su
linaje y la etiqueta de validación.

> **Trampa:** si registras el modelo desde un cuaderno con celdas ejecutadas
> fuera de orden, el linaje apunta a algo que no puedes reproducir. Registra
> desde un script.

---

### 15. Promover con un alias, y revertir

Asigna el alias `champion` a la versión que elegiste y **cambia tu servicio**
para que cargue por alias, no por número de versión.

Luego ejecuta una reversión: reasigna `champion` a la versión anterior y
comprueba que el servicio devuelve las predicciones viejas **sin volver a
desplegar nada**.

**Entrega:** las dos salidas del mismo `curl` antes y después de reasignar el
alias, con el campo `modelo` de la respuesta cambiando.

> Cronométralo. Si tu reversión tarda más de un minuto, todavía no tienes una
> reversión: tienes un redespliegue.

---

### 16. Las compuertas, en CI

Escribe el flujo de integración continua (GitHub Actions o equivalente) que
**impide** registrar un modelo que no cumpla. Como mínimo cuatro compuertas:

| Compuerta | Criterio sugerido |
|---|---|
| Desempeño | AUROC no peor que la versión en producción |
| Calibración | Brier no empeora |
| Equidad | ningún subgrupo cae más de 5 puntos porcentuales |
| Contrato | el esquema de entrada no cambió sin subir versión mayor |

**Entrega:** el archivo del flujo + **dos corridas**: una que pasa y una que
falla a propósito, con el registro mostrando que la segunda no se registró.

> Fallar a propósito es parte de la actividad. Una compuerta que nunca se ha
> visto fallar no se sabe si funciona.

---

### 17. Elegir estrategia de actualización

Media cuartilla: para **tu** caso de uso, ¿cómo sacarías la versión 3?

Decide entre despliegue escalonado (una sala sí, otra no), canario por
porcentaje de tráfico, o sombra. Justifica con el volumen de predicciones que
esperas y con lo rápido que te enterarías de que algo salió mal.

Incluye la tabla del plan de apagado:

| | |
|---|---|
| **Quién** lo apaga | nombre y puesto, no «el equipo» |
| **Con qué criterio** | un número y un umbral concretos |
| **En cuánto tiempo** | desde que suena la alarma hasta que se apaga |
| **Qué pasa mientras** | a qué vuelve el servicio clínico |

**Entrega:** la justificación y la tabla. Si no puedes llenarla, eso **es** el
hallazgo.

---

### 18. La *model card*

Escribe `MODEL_CARD.md`, **una página**, junto al modelo registrado.

Lo que el registro ya tiene —versión, métricas, linaje, fecha— cópialo o
genéralo. Lo que tienes que escribir tú: uso previsto, población, desempeño
**por subgrupo** con la prevalencia local, limitaciones y mantenimiento.

**Entrega:** el archivo. Si una sección te queda vacía, déjala vacía y marca
«pendiente» — una model card honesta con huecos vale más que una completa a
base de relleno.

---

## Checklist de entrega

- [ ] El artefacto incluye calibrador, umbral, esquema y versiones
- [ ] Un compañero reprodujo las diez predicciones hasta el tercer decimal
- [ ] Los formatos de serialización se **midieron**, no se supusieron
- [ ] El esquema de entrada rechaza valores fisiológicamente imposibles
- [ ] Las dos latencias (modelo mal y bien cargado) están medidas
- [ ] La respuesta del endpoint permite auditar qué versión produjo qué alerta
- [ ] El servicio corre dentro de un contenedor con versiones fijas
- [ ] El skew se reprodujo y se reportó **qué métrica avisó primero**
- [ ] El PSI tiene pruebas, incluida la del bin vacío
- [ ] Los umbrales de alarma se fijaron **antes** de ver los resultados
- [ ] Hay **dos versiones registradas** con su linaje y su etiqueta de validación
- [ ] El servicio carga por **alias**, no por número de versión
- [ ] La reversión se ejecutó de verdad y tomó menos de un minuto
- [ ] El flujo de CI tiene cuatro compuertas y **una corrida que falla a propósito**
- [ ] La estrategia de actualización está justificada con números
- [ ] `MODEL_CARD.md` cabe en una página y tiene subgrupos
- [ ] El plan de apagado tiene un nombre propio y un número
- [ ] `gitleaks` pasa y no hay datos de pacientes en el repositorio

---

## Para ir más lejos (opcional)

- **Shadow mode.** Haz que el servicio prediga sobre datos reales sin que nadie
  vea el resultado, y compara con la conducta que de hecho se tomó. Es la forma
  más barata de validar el skew contra la realidad.
- **El bucle.** Simula que a los pacientes marcados se les trata y su riesgo
  real baja. Mide cuánto cae el AUROC *observado*. Después reentrena con esos
  datos y observa cómo el modelo deja de marcarlos: se desactiva solo.
- Lee a [Finlayson et al. (2021)](https://doi.org/10.1056/NEJMc2104626) sobre
  *dataset shift* y clasifica tu propia deriva con su taxonomía.
- **Compara tu pipeline con uno real.** Lee cómo Duke llevó Sepsis Watch a la
  urgencia ([Sendak et al., 2020](https://medinform.jmir.org/2020/7/e15182/)) y
  marca, de sus ocho etapas, cuáles has hecho y cuáles ni siquiera habías
  considerado.

---

## Estructura sugerida

```
s26-deployment-etica/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab26: <descripción breve>` y solicita revisión.
