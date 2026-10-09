# Laboratorio 19 — Configurar una cuenta AWS de forma segura

**Sesión 19:** AWS Fundamentos: IAM, Regiones y AWS CLI
**Bloque:** IV — Cómputo en la nube

## Objetivo

Dejar tu cuenta **segura y con frenos de costo** antes de tocar un solo
servicio. Al terminar vas a poder operar AWS desde la terminal y desde Python
**sin una sola credencial en el código**.

Este es el único laboratorio del curso que puede costarte dinero real si lo
haces mal. Por eso las dos primeras actividades son el MFA y el presupuesto.

---

## Antes de empezar

**Necesitarás:** una tarjeta (AWS la pide aunque uses Free Tier), `python`,
`boto3` y la **AWS CLI v2**.

> **Reglas del laboratorio, no negociables:**
>
> 1. **Nunca** subas datos de pacientes reales. Ni sintéticos de tu hospital.
>    Para este laboratorio basta con archivos de prueba que tú inventes.
> 2. **Nunca** pegues una credencial en un archivo del repositorio. Se verifica
>    con `gitleaks` y una credencial en un commit es un error de entrega.
> 3. Si algo te parece caro o raro, **apágalo y pregunta**. No lo dejes corriendo
>    «a ver qué pasa».

Material complementario: [`recursos/s19-aws-fundamentos-iam.md`](../../recursos/s19-aws-fundamentos-iam.md)

---

## Parte A — Lo que va primero

### 1. Cuenta y MFA en la raíz

Crea tu cuenta AWS y, **antes de cualquier otra cosa**, activa MFA en la cuenta
raíz.

**Entrega:** captura de la pantalla de seguridad de la raíz mostrando MFA
activo, con los datos identificables tapados.

> La cuenta raíz puede hacer **todo**, incluida cerrar la cuenta y cambiar la
> facturación. Después de hoy la usarás sólo para facturación. Para trabajar,
> nunca.

---

### 2. El presupuesto, antes que nada

Crea un presupuesto de **$5 USD** con alertas por correo al **50 %** y al
**80 %**, tanto de gasto real como de gasto **previsto**.

**Entrega:** captura de la configuración y el correo de confirmación.

> Dos minutos. Es el seguro contra la historia que todos hemos oído de la
> factura sorpresa. Hazlo **antes** de la actividad 3, no después.

---

### 3. Tu usuario IAM

Crea un usuario IAM para ti, con acceso a consola. Activa MFA también en él.
Cierra la sesión de la raíz y vuelve a entrar como tu usuario.

**Entrega:** confirmación de que puedes trabajar sin la raíz, y una frase sobre
qué permisos le diste y por qué.

> **Trampa.** Es tentador darte `AdministratorAccess` y seguir. Hazlo si quieres,
> pero **decláralo** y explica qué permisos necesitas realmente para este
> laboratorio. La actividad 5 te va a pedir lo contrario.

---

## Parte B — Privilegio mínimo

### 4. Un bucket y un objeto de prueba

Crea un bucket (nombre único global) con un prefijo `publico/` y otro
`privado/`. Sube un archivo de texto cualquiera a cada uno.

**Entrega:** el nombre del bucket y la estructura.

> **Trampa.** El bucket se crea **bloqueando el acceso público** por default.
> Déjalo así. «Público» aquí es sólo el nombre del prefijo, no una configuración.

---

### 5. Escribe la política

Escribe `politica_minima.json`: una política que permita **únicamente**
`s3:GetObject` sobre `arn:aws:s3:::TU-BUCKET/publico/*`.

Nada más. Ni `s3:*`, ni `Resource: "*"`, ni el bucket completo.

**Entrega:** el JSON, comentado en tu README renglón por renglón: qué hace cada
una de las cuatro claves.

> **Trampa 1.** Para *listar* el contenido de un bucket hace falta
> `s3:ListBucket`, y su `Resource` es el **bucket**, no los objetos. Son dos ARN
> distintos y es el error clásico. Decide si lo necesitas o no, y justifícalo.
>
> **Trampa 2.** El ARN de un objeto lleva `/*` al final; el del bucket, no.

---

### 6. Pruébala antes de aplicarla

Usa el **IAM Policy Simulator** para verificar, sin tocar nada:

| Debe | Acción | Recurso |
|---|---|---|
| permitir | `s3:GetObject` | `…/publico/archivo.txt` |
| denegar | `s3:GetObject` | `…/privado/archivo.txt` |
| denegar | `s3:PutObject` | `…/publico/archivo.txt` |
| denegar | `s3:DeleteObject` | cualquiera |

**Entrega:** la tabla con el resultado real de cada caso y una captura del
simulador.

> Si alguno sale distinto de lo esperado, **no lo ajustes a ciegas**: explica por
> qué pasó. Casi siempre es el ARN, o un permiso heredado de otra política.

---

## Parte C — Operar sin llaves en el código

### 7. La CLI con perfil nombrado

Configura la AWS CLI con un perfil llamado `tesis` y verifica:

```bash
aws sts get-caller-identity --profile tesis
```

**Entrega:** la salida del comando con el `Account` y el `UserId` tapados, y la
confirmación de que `~/.aws/` **no** está dentro del repositorio.

> `sts get-caller-identity` es el «hola mundo» de AWS: contesta quién eres y con
> qué cuenta. Es lo primero que se corre cuando algo falla.

---

### 8. boto3, sin credenciales

Desde un notebook, usa el perfil para listar tus buckets y descargar el objeto
de `publico/`.

**Entrega:** el notebook. La única referencia a credenciales que puede aparecer
es el **nombre del perfil**.

> **Trampa.** Si tu notebook funciona pero tiene una llave escrita, no cuenta. Si
> no sabes cómo pasarle el perfil a `boto3`, la respuesta está en su
> documentación de sesiones — no en pegar la llave «sólo para probar».

---

### 9. Verifica que no filtraste nada

Corre `gitleaks` sobre tu repositorio, incluyendo el **historial**.

**Entrega:** la salida limpia.

> **Si encuentra algo:** la credencial ya se expuso. **Rótala en la consola de
> AWS** —no basta con borrar el commit— y después limpia el historial. Documenta
> lo que pasó: eso vale más que no haberlo cometido.

---

### 10. Que alguien más lo pueda repetir

Escribe en `aws-setup.md` las instrucciones para que un compañero reproduzca tu
configuración **en su propia cuenta**, sin recibir ninguna credencial tuya.

**Entrega:** el documento. Pásaselo a alguien del grupo y que lo siga de verdad;
anota dónde se atoró.

---

## Entregable

1. `aws-setup.md` — el procedimiento reproducible, con capturas censuradas
2. `politica_minima.json` — la política, comentada en el README
3. `simulador.md` — la tabla de casos probados y su resultado
4. `verificacion.ipynb` — boto3 con perfil, sin llaves

---

## Criterios de evaluación

- [ ] MFA activo en la cuenta raíz, y la raíz no se usa para trabajar
- [ ] Presupuesto con alertas configurado **y documentado**
- [ ] La política es genuinamente mínima: no hay `s3:*` ni `Resource: "*"`
- [ ] Los cuatro casos del simulador están probados, con su resultado real
- [ ] El notebook usa un perfil nombrado; **cero** credenciales en el repositorio
- [ ] `gitleaks` pasa limpio sobre el historial completo
- [ ] No se subió ningún dato de paciente
- [ ] Otra persona pudo seguir tu `aws-setup.md` sin tus credenciales
- [ ] El código está versionado con commits descriptivos

---

## Al terminar: apaga la luz

- Borra el bucket y su contenido
- Revisa **Cost Explorer**: ¿cuánto costó este laboratorio?
- Deja el presupuesto activo. Te va a servir toda la sesión 20 y 21

> Acostúmbrate a cerrar lo que abres. En la sesión 21 vamos a encender máquinas
> que sí cuestan por hora.

---

## Para ir más lejos (opcional)

- Agrega una `Condition` a tu política que exija MFA presente
  (`aws:MultiFactorAuthPresent`) y vuelve a pasar por el simulador.
- Corre **IAM Access Analyzer** sobre tu cuenta y revisa qué señala.
- Estima en la [calculadora de AWS](https://calculator.aws/) cuánto costaría
  guardar y sacar los datos de tu proyecto final durante un año.

---

## Estructura sugerida

```
s19-aws-fundamentos-iam/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab19: <descripción breve>` y solicita revisión.
