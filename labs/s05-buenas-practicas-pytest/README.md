# Laboratorio 05 — Convertir un notebook en un paquete probado

**Sesión 05:** Buenas Prácticas de Programación y Testing con pytest
**Bloque:** II — Ingeniería de software para científicos

## Objetivo

Convertir el análisis del laboratorio 2 en `clinlab`: un **paquete instalable,
con pruebas que atrapan los errores que tú mismo encontraste** en aquellos datos,
y calidad automatizada en capas. Cada hallazgo del laboratorio 2 se convierte en un test permanente

---

## Antes de empezar

Trabaja en **tu propio Jupyter/editor local**. Este laboratorio necesita
terminal y git; en Colab se puede, pero pelearás contra la corriente
(pre-commit y la estructura de paquete asumen un repositorio local).

**Necesitarás:** `pandas pytest pytest-cov ruff mypy pre-commit`
(opcional para el bono: `hypothesis pandera`)

Material complementario: [`recursos/s05-buenas-practicas-pytest.md`](../../recursos/s05-buenas-practicas-pytest.md)

**Punto de partida:** tu notebook `analisis_pacientes.ipynb` del laboratorio 2
y los CSV de Synthea que generaste entonces.

---

## Actividades

### 1. El esqueleto del paquete

Crea la estructura estándar con *layout* `src/`:

```text
clinlab/
├── pyproject.toml
├── src/clinlab/__init__.py
├── tests/
└── notebooks/
```

Escribe el `pyproject.toml` desde cero (nombre, versión, dependencias,
grupo `dev`). Instala con `pip install -e ".[dev]"` y comprueba que
`import clinlab` funciona **desde cualquier directorio**, no sólo desde la
raíz del proyecto.

**Entrega:** el `pyproject.toml` y la salida de esa comprobación.

---

### 2. Extraer la lógica del notebook

Relee tu notebook del laboratorio 2 y encuentra **al menos cinco piezas de
lógica** que merezcan ser funciones. Candidatas naturales: convertir dtypes,
detectar fechas imposibles, marcar valores fuera de rango fisiológico, unir
las tres tablas validando cardinalidad, clasificar por grupo etario.

Muévelas a módulos dentro de `src/clinlab/`, como **funciones puras**: entra
un DataFrame (o valores), sale un resultado. Nada de `read_csv` ni `to_csv`
dentro — el I/O se queda en el notebook, que ahora **importa** el paquete.

> La prueba de fuego: si una función necesita que exista un archivo para
> poder probarse, todavía no está bien extraída.

**Entrega:** el notebook reescrito, más corto, importando de `clinlab`.

---

### 3. El contrato: tipos y docstrings

Añade *type hints* y docstring a cada función pública. En datos clínicos hay
una regla no negociable: **las unidades van en el docstring** (¿creatinina en
mg/dL o µmol/L? ¿edad en años?).

Corre `mypy src/` hasta que pase sin errores.

---

### 4. Primeras pruebas

Escribe las primeras pruebas para dos o tres funciones: caso normal y caso
de error esperado (`pytest.raises`).

**Obligatorio:** para al menos una prueba, documenta el ciclo completo:
captura de la prueba **fallando** (rojo), luego el código que la hace pasar
(verde). Una prueba que nunca viste fallar puede estar probando nada.

**Pistas:** `pytest.approx` para todo flotante, sin excepción. Los nombres
largos y descriptivos (`test_excluye_visitas_previas_al_nacimiento`) son
documentación, no verbosidad.

---

### 5. La fixture maliciosa

En `tests/conftest.py`, construye una fixture con un DataFrame **pequeño y
malicioso**: 5–8 pacientes que entre todos cubran un caso normal, un menor de
edad, un NaN, un duplicado de `person_id`, una fecha imposible y un valor
centinela (edad 180 o HbA1c 0 — los conoces del laboratorio 2).

Ese es tu dato de prueba para casi todo lo que sigue. Un buen dato de prueba
no es realista y grande: es chico y con trampas deliberadas.

---

### 6. La tabla de validación clínica

Si tu paquete calcula algo clínico (eGFR, IMC, grupo etario), valida contra
una **referencia externa**: la calculadora CKD-EPI 2021 de
[kidney.org](https://www.kidney.org/professionals/gfr_calculator), un artículo,
o los rangos de MDCalc.

Usa `@pytest.mark.parametrize` con **al menos 8 combinaciones** que tú mismo
verifiques en la referencia (incluye extremos: ERC avanzada, creatinina muy
baja). Anota en el docstring del test de dónde salió cada valor esperado.

> Los valores de la diapositiva son ilustrativos. Los tuyos deben ser
> verificados por ti — eso ES el ejercicio.

---

### 7. Los hallazgos del lab 2 se vuelven tests

Recorre la lista de casos límite y escribe una prueba por cada uno, contra
tus propias funciones:

- DataFrame vacío → ¿truena o devuelve vacío coherente? (decide y pruébalo)
- Columna entera de NaN
- Fecha de visita anterior al nacimiento
- `person_id` duplicado → ¿tu join multiplica filas?
- Valor centinela (edad 180, HbA1c 0)

**Entrega:** cada prueba lleva un comentario de una línea: qué hallazgo del
laboratorio 2 la motivó.

---

### 8. Cobertura como diagnóstico

Configura `pytest-cov` en el `pyproject.toml` y alcanza **≥80%** de cobertura
con `--cov-report=term-missing`.

Después, lo importante: mira las líneas NO cubiertas y escribe tres renglones:
¿qué queda sin probar y por qué está bien (o no) que así sea? 80% con casos
límite vale más que 100% de asserts triviales.

---

### 9. Automatizar: pre-commit

Configura `.pre-commit-config.yaml` con `ruff`, `ruff-format` y `mypy`.
Recuerda: **el YAML solo no hace nada** — hace falta `pre-commit install` en
cada clon, y ese paso va documentado en tu README.

**Demuestra que funciona:** provoca un commit con código que ruff rechace y
captura el rechazo; corrige y confirma.

---

### 10. La tercera capa: CI (Opcional)

Añade un workflow de GitHub Actions que corra `ruff check` y `pytest` en cada
push (ya escribiste uno en el laboratorio 4 — adáptalo). Badge en el README.

Si protegiste `main` en el laboratorio 4: activa *require status checks* para
que nada entre con la suite en rojo. Las tres capas quedan cerradas.

---

### Bono — nivel industrial

- **Hypothesis:** una propiedad para tu función clínica (p. ej. «el eGFR
  siempre es positivo» o «a mayor creatinina, menor eGFR, todo lo demás fijo»).
  Documenta si encontró algo que no esperabas.
- **Pandera:** el esquema de tu tabla de pacientes como contrato ejecutable,
  con los rangos fisiológicos que investigaste en el laboratorio 3.

---

## Entregable

Repositorio (puede ser el mismo del lab 4) donde, en un clon limpio:

```bash
pip install -e ".[dev]" && pytest
```

funciona desde cero. Con: paquete `src/clinlab`, suite con la fixture
maliciosa y la tabla de validación, cobertura ≥80% reportada, pre-commit
configurado y CI en verde.

**No subas los CSV.** Tus pruebas no los necesitan: para eso es la fixture.

---

## Criterios de evaluación

- [ ] `pip install -e ".[dev]" && pytest` funciona en un clon limpio
- [ ] Ninguna función de `src/` lee ni escribe archivos
- [ ] Todas las funciones públicas declaran tipos y unidades
- [ ] Hay evidencia de al menos una prueba vista en rojo antes del verde
- [ ] La tabla de `parametrize` cita su referencia externa
- [ ] Cada caso límite del lab 2 tiene su test, con el comentario de origen
- [ ] Cobertura ≥80% **y** el análisis de lo no cubierto
- [ ] Captura del commit rechazado por pre-commit
- [ ] `mypy` y `ruff check` pasan; CI en verde con badge
- [ ] Los flotantes se comparan con `pytest.approx`, nunca con `==`

---

## Si te atoras

- **`import clinlab` no funciona fuera de la raíz:** no instalaste con `-e`,
  o el layout `src/` está mal armado. Revisa `pip show clinlab`.
- **pytest no encuentra tus tests:** convenciones — `tests/test_*.py`,
  funciones `test_*`.
- **mypy se queja de pandas:** los stubs son imperfectos; está bien un
  `ignore` puntual **documentado**, no un `ignore` global.
- **pre-commit no corre en tus commits:** te faltó `pre-commit install`.
  Es la trampa clásica; ahora ya sabes por qué va en el README.
- **La cobertura no sube de 60%:** seguramente tienes lógica todavía en el
  notebook. Extráela; lo que no está en `src/` no se puede cubrir.

## Estructura sugerida

```text
s05-buenas-practicas-pytest/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # o un repositorio aparte, enlazado desde aquí
```
