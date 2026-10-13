# Laboratorio 21 — Ejecutar un análisis en la nube

**Sesión 21:** Amazon EC2: Cómputo en la Nube para Ciencia de Datos
**Bloque:** IV — Cómputo en la nube

## Objetivo

Correr **tu** pipeline containerizado en una instancia EC2, leyendo de S3 y
escribiendo a S3, **sin una sola credencial guardada en la máquina**. Y dejarlo
todo apagado, con el costo medido.

Aquí se cierra el arco del curso: la imagen de la sesión 6, el bucket de la 20,
y hoy el cómputo.

---

## Antes de empezar

**Necesitarás:** la cuenta y el perfil de la sesión 19, el bucket de la sesión 20,
tu imagen de contenedor de la sesión 6 publicada en un registro, y un cliente SSH.

> **Este es el laboratorio que cuesta dinero de verdad.**
>
> 1. El presupuesto de la sesión 19 tiene que estar activo. Verifícalo **ahora**.
> 2. Usa `t3.medium` o menor salvo que justifiques otra cosa.
> 3. **Apaga al terminar.** La actividad 10 es obligatoria, no decorativa.
> 4. Levanta la instancia en la **misma región** que tu bucket, o vas a pagar
>    transferencia entre regiones sin darte cuenta.

Material complementario: [`recursos/s21-aws-ec2.md`](../../recursos/s21-aws-ec2.md)

---

## Parte A — Antes de encender

### 1. Justifica la instancia

Antes de lanzar nada, responde por escrito:

- ¿cuánta **memoria** necesita tu trabajo? ¿cómo lo sabes?
- ¿cuánto tarda en tu laptop?
- ¿por qué EC2 y no Lambda, Batch, Fargate o simplemente tu máquina?

**Entrega:** tres párrafos cortos y el tipo de instancia que elegiste, con su
razón.

> Si la respuesta honesta es «mi laptop alcanza», dilo. Haz el laboratorio de
> todos modos —es el ejercicio— pero el análisis cuenta.
>
> **Trampa.** Las instancias `t` son *burstables*: acumulan créditos de CPU y se
> frenan cuando se agotan. Van bien para pruebas y muy mal para un trabajo largo.
> Si tu instancia se vuelve lentísima a la media hora, ya sabes por qué.

---

### 2. El rol, antes que la instancia

Crea un rol IAM para la instancia que permita **sólo** leer de tu prefijo de
datos y escribir en `results/`. Nada más.

**Entrega:** el JSON de la política, y la confirmación de que lo probaste en el
simulador (sesión 19).

---

## Parte B — Lanzar

### 3. La instancia

Lánzala con:

- el **rol** de la actividad 2 adjunto
- un grupo de seguridad que permita SSH **sólo desde tu IP**, con `/32`
- un volumen gp3 del tamaño mínimo que necesites

**Entrega:** la configuración y una captura del grupo de seguridad.

> **Trampa.** Tu IP cambia. Si configuras la de tu casa y al día siguiente
> intentas entrar desde la universidad, no vas a poder: eso es correcto, no es un
> error. Actualiza la regla.
>
> Si en algún momento te dan ganas de poner `0.0.0.0/0` «sólo para probar», ésa
> es exactamente la decisión que esta actividad existe para evitar.

---

### 4. `user data`

Escribe un script de arranque que instale Docker y deje la máquina lista sin que
entres a configurarla a mano.

**Entrega:** el script, y la evidencia de que funcionó (puedes revisar el log de
arranque de la instancia).

> Si tuviste que entrar por SSH a arreglar algo que el script debía hacer,
> **arregla el script** y relanza. Ése es el punto: la instancia es reproducible.

---

## Parte C — Correr

### 5. Tu contenedor, sobre tus datos

Baja tu imagen y corre el pipeline leyendo de S3 y escribiendo a S3.

**Entrega:** el comando completo y la salida.

---

### 6. Demuestra que no hay llaves

Comprueba y documenta que la instancia **no** guarda credenciales:

- no existe `~/.aws/credentials`
- tu código no tiene ninguna llave
- aun así, `aws sts get-caller-identity` responde — y lo que devuelve es el
  **rol**, no un usuario

**Entrega:** la salida del comando (con la cuenta tapada) y una frase explicando
de dónde salieron esas credenciales y por qué caducan.

> **Es el criterio de evaluación más importante del laboratorio.** Si hay una
> llave en la instancia, no cuenta aunque todo lo demás funcione.

---

### 7. Jupyter sin abrir puertos

Levanta Jupyter escuchando en `localhost` dentro de la instancia y llega a él
desde tu navegador por un **túnel SSH**.

**Entrega:** el comando del túnel y una captura del notebook corriendo.

> **Nunca** abras el 8888 al internet. Un Jupyter expuesto es ejecución remota de
> código como servicio, y hay buscadores que los indexan.

---

### 8. Que sobreviva a la desconexión

Lanza un trabajo largo dentro de `tmux`, cierra la sesión SSH, vuelve a entrar y
recupera la sesión.

**Entrega:** la secuencia de comandos y la evidencia de que el trabajo siguió.

---

## Parte D — Costo

### 9. Spot

Repite el trabajo en una instancia **spot** y compara.

**Entrega:** el precio spot que obtuviste frente al on-demand del mismo tipo, y
un párrafo: ¿tu trabajo tolera que te quiten la máquina con 2 minutos de aviso?
Si no, ¿qué tendrías que cambiar para que sí?

> Si tu trabajo no tiene *checkpoints*, spot puede costarte más tiempo del que te
> ahorra en dinero. Decirlo así es una respuesta correcta.

---

### 10. Apaga la luz, y mídelo

- Configura una alarma de CloudWatch que **apague la instancia** si la CPU está
  baja durante N horas
- Termina o detén todas las instancias
- Revisa Cost Explorer y reporta el **costo real** del laboratorio

**Entrega:** la alarma, la captura de que no queda nada encendido, y el costo con
su desglose.

> Ojo con la diferencia: una instancia **detenida** no cobra cómputo pero **sí**
> cobra el disco EBS, todos los días. Una **terminada** no cobra nada —y pierde
> el disco.

---

## Entregable

`ec2-lab.md` con:

1. La justificación de la instancia y el tipo elegido
2. El JSON del rol y la evidencia del simulador
3. El script de `user data`
4. Los comandos de ejecución y la salida del pipeline
5. La demostración de que no hay credenciales en la máquina
6. El comando del túnel SSH
7. La comparación spot vs on-demand
8. La alarma de apagado, la evidencia de apagado y el costo medido

---

## Criterios de evaluación

- [ ] **Ninguna credencial de AWS** está almacenada en la instancia (demostrado)
- [ ] El puerto 22 **no** está abierto a `0.0.0.0/0`
- [ ] Jupyter nunca estuvo expuesto a internet
- [ ] El rol de instancia es de privilegio mínimo, no `AmazonS3FullAccess`
- [ ] El `user data` deja la máquina lista sin intervención manual
- [ ] El pipeline lee y escribe en S3, no en el disco de la instancia
- [ ] La instancia quedó **terminada o detenida** al final
- [ ] Hay una alarma de apagado automático configurada
- [ ] El costo reportado viene de Cost Explorer, no de una estimación
- [ ] Cero credenciales en el repositorio (`gitleaks` limpio)

---

## Para ir más lejos (opcional)

- Entra a la instancia con **Session Manager**, sin abrir el puerto 22 en absoluto.
- Instala el agente de CloudWatch para ver la **memoria** (no viene por default) y
  revisa si tu instancia estaba sobrada o corta.
- Agrega *checkpoints* a tu pipeline: que guarde avances a S3 cada N pasos y pueda
  reanudar. Después vuelve a correrlo en spot sin miedo.
- Prueba una instancia **Graviton** (ARM, por ejemplo `t4g.medium`) y compara
  precio y tiempo. Tu imagen tiene que estar construida para `arm64`.

---

## Estructura sugerida

```
s21-aws-ec2/
├── README.md          # este archivo (el enunciado)
└── tu-entrega/        # todo lo que construyas va aquí
```

## Entrega

Abre un Pull Request contra tu rama `main` con el título
`lab21: <descripción breve>` y solicita revisión.
