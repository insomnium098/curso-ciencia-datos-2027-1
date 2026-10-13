# Material complementario — Sesión 21

## Amazon EC2: Cómputo en la Nube para Ciencia de Datos

*Bloque IV — Cómputo en la nube*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Seleccionar el tipo de instancia adecuado para una carga de trabajo de datos
- Lanzar, configurar y asegurar una instancia EC2
- Ejecutar cargas de trabajo containerizadas en la nube
- Reducir costos con instancias spot, apagado automático y dimensionamiento correcto

## Empieza por aquí

- ★ [**EC2 — Security best practices**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-best-practices.html)
  La checklist oficial. El grupo de seguridad y el rol de instancia salen de aquí.
- [**instances.vantage.sh**](https://instances.vantage.sh/)
  Comparador no oficial de tipos y precios de EC2, mucho más legible que la tabla de AWS. Filtra por memoria y ordena por precio: así se elige una instancia.
- [**EC2 Instance Types**](https://aws.amazon.com/ec2/instance-types/)
  La referencia oficial de todas las familias.

## Lanzar y asegurar

- ★ [**Amazon EC2 — User Guide**](https://docs.aws.amazon.com/ec2/)
  La referencia principal.
- [**Roles de IAM para instancias EC2**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)
  **Lo más importante de la sesión**: cómo la instancia accede a S3 sin guardar ninguna llave.
- [**Servicio de metadatos de instancia (IMDSv2)**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configuring-instance-metadata-service.html)
  De dónde salen esas credenciales temporales, y por qué IMDSv2 y no v1.
- [**Ejecutar comandos al arrancar (user data)**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)
  El script que convierte «lo configuré a mano» en algo reproducible.
- [**Grupos de seguridad**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html)
  El firewall de la instancia. Nunca `0.0.0.0/0` en el puerto 22.
- [**AWS Systems Manager Session Manager**](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)
  Entrar a la instancia **sin abrir ningún puerto**, con control por IAM y bitácora de quién entró.
- [**Volúmenes EBS**](https://docs.aws.amazon.com/ebs/latest/userguide/what-is-ebs.html)
  gp3 para casi todo. Ojo: el disco cobra aunque la instancia esté detenida.

## Costos

- ★ [**EC2 Pricing**](https://aws.amazon.com/ec2/pricing/)
  On-demand, spot y planes de ahorro.
- [**EC2 Spot Instances**](https://aws.amazon.com/ec2/spot/)
  Cómo funcionan, cuánto avisan antes de quitártela y cuándo conviene.
- [**Buenas prácticas para spot**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-best-practices.html)
  Diseñar para interrupción: *checkpoints* y manejo del aviso de dos minutos.
- [**Detener frente a terminar una instancia**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html)
  La diferencia que más dinero cuesta cuando se confunde.
- [**Acciones de alarma de CloudWatch (apagado automático)**](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/UsingAlarmActions.html)
  El seguro de dos minutos contra la factura del fin de semana largo.

## Cómputo científico

- ★ [**AWS Batch**](https://docs.aws.amazon.com/batch/)
  Trabajos en lote con contenedores, sin gestionar servidores.
- [**AWS HealthOmics**](https://aws.amazon.com/healthomics/)
  Servicio gestionado para pipelines genómicos (WDL/Nextflow).
- [**Amazon SageMaker**](https://docs.aws.amazon.com/sagemaker/)
  Entrenamiento y despliegue de modelos gestionado. Relevante para la sesión 26.
- [**AWS HPC**](https://aws.amazon.com/hpc/)
  Arquitecturas de cómputo de alto rendimiento.

## Operación

- ★ [**tmux cheat sheet**](https://tmuxcheatsheet.com/)
  Para que tu trabajo sobreviva a la desconexión.
- [**SSH tunneling explained**](https://www.ssh.com/academy/ssh/tunneling)
  Cómo llegar a Jupyter sin exponerlo: el túnel es la respuesta correcta, abrir el 8888 no lo es.
- [**Agente de CloudWatch**](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)
  La métrica de **memoria** no viene por default en EC2. Si quieres saber si te quedaste corto, hay que instalarlo.

