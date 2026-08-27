# Laboratorio 04 — Flujo completo de colaboración con pull requests

**Sesión 04:** Control de Versiones con Git y GitHub
**Bloque:** II — Ingeniería de software para científicos

## Objetivo

Practicar el ciclo de trabajo real de un equipo de datos: issues, ramas, PRs con revisión y main protegida.

## Antes de empezar

Trabaja donde prefieras: **Google Colab** o **tu propio Jupyter**. No hay entorno que levantar desde este repositorio — montarlo es parte de tu trabajo.

**Necesitarás:** `pandas numpy matplotlib`

Opciones y sus límites: [`docs/entorno-alumno.md`](../../docs/entorno-alumno.md)

Revisa antes el material complementario: [`recursos/s04-git-github.md`](../../recursos/s04-git-github.md)

## Actividades

### 1. Inicializar un repositorio, configurar `user.name`/`user.email` y hacer 5 commits con Conventional Commits

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 2. Escribir un `.gitignore` adecuado (datos, entornos, basura de herramientas) y demostrar con `git rm --cached` cómo se saca un archivo que ya estaba rastreado

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 3. Abrir 2 issues bien escritos (título concreto, pasos reproducibles, etiqueta) que describan trabajo por hacer

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 4. Crear una rama por issue y abrir un **draft PR** desde el primer commit de cada una

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 5. Al terminar una rama: marcar el PR como *ready for review* y cerrar el issue con `fixes #N` en el mensaje

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 6. Provocar deliberadamente un conflicto de merge entre dos ramas y resolverlo

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 7. **Proteger `main`**: requerir PR, ≥1 aprobación y CI en verde. Comprobar que el push directo rebota

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 8. Hacer fork del repositorio de un compañero y abrirle un PR; revisar el PR que te abran con ≥2 comentarios y al menos una ```suggestion``` aplicable

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 9. Agregar un workflow de GitHub Actions que corra `ruff` y `pytest` en cada push

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

### 10. Recuperar con `git reflog` un commit borrado con `reset --hard`

<!-- TODO: detallar el enunciado y las pistas. NO incluir código resuelto. -->

## Entregable

URL del repositorio con: main protegida, ≥2 issues cerrados desde PRs, ≥1 PR mergeado con revisión, ≥1 PR revisado a un compañero, CI en verde.

## Criterios de evaluación

- [ ] Ningún mensaje de commit dice 'update', 'fix' a secas o 'asdf'
- [ ] Los issues se cerraron automáticamente con `fixes #N`, no a mano
- [ ] La protección de `main` está activa y se demuestra (captura del push rechazado)
- [ ] La revisión que diste incluye al menos una sugerencia aplicable, no sólo opiniones
- [ ] El badge de CI aparece en verde en el README
- [ ] El código está versionado en tu repositorio con commits descriptivos
- [ ] `ruff check` y `pytest` pasan (cuando aplique)

## Estructura sugerida

```
s04-git-github/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título `lab04: <descripción breve>` y solicita revisión.

