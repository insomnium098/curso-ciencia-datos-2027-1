# Laboratorio 03 — EDA completo sobre tu cohorte de Synthea

**Sesión 03:** Python para Biomedicina: Visualización y Análisis Exploratorio
**Bloque:** I — Fundamentos de Python para datos biomédicos

## Objetivo

Producir un reporte exploratorio que un colega clínico pueda leer y entender.

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**. No hay entorno que levantar desde este repositorio — montarlo es parte de tu trabajo.

**Necesitarás:** `pandas matplotlib seaborn plotly`


Revisa antes el material complementario: [`recursos/s03-visualizacion-eda.md`](../../recursos/s03-visualizacion-eda.md)

## Actividades

### 1. Partir del dataset de Synthea que preparaste en la sesión 2 y definir una cohorte de interés (por ejemplo, pacientes con diabetes)

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 2. Ejecutar el checklist completo de EDA sobre esa cohorte

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 3. Generar y comentar: distribución de edad por sexo, evolución temporal de un analito, comorbilidades más frecuentes

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 4. Detectar al menos dos problemas de calidad que **sólo** sean visibles graficando, y que no hubieras encontrado con `describe()`

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 5. Construir una figura multipanel (2×2) con tamaño y tipografía de publicación

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 6. Reproducir la misma figura clave en matplotlib puro, en seaborn y en plotly; comparar esfuerzo, control y resultado

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 7. Construir la tabla de características basales (Tabla 1) de tu cohorte

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 8. Exportar la figura final en PDF vectorial y en PNG a 300 dpi

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

## Entregable

Notebook `eda_cohorte.ipynb` + carpeta `figuras/` con los archivos exportados + la Tabla 1.

## Criterios de evaluación

- [ ] Todas las figuras tienen ejes etiquetados con unidades
- [ ] Ninguna figura usa una paleta no perceptualmente uniforme ni ejes truncados sin advertirlo
- [ ] Cada figura tiene un título que enuncia la conclusión, no que describe los ejes
- [ ] El notebook cierra con 3 hallazgos redactados en lenguaje clínico
- [ ] El código está versionado en tu repositorio con commits descriptivos
- [ ] `ruff check` y `pytest` pasan (cuando aplique)

## Estructura sugerida

```
s03-visualizacion-eda/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título `lab03: <descripción breve>` y solicita revisión.

