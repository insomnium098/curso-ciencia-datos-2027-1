# Material complementario — Sesión 19

## AWS Fundamentos: IAM, Regiones y AWS CLI

*Bloque IV — Cómputo en la nube*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Explicar el modelo de responsabilidad compartida y sus implicaciones para datos de salud
- Configurar usuarios, roles y políticas IAM aplicando privilegio mínimo
- Operar AWS desde la CLI y desde Python con credenciales seguras
- Estimar y controlar costos antes de recibir la factura

## Empieza por aquí

- ★ [**IAM — Security best practices**](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
  La checklist oficial. Aplícala entera antes de hacer cualquier otra cosa: es exactamente la parte A del laboratorio.
- [**AWS Cloud Practitioner Essentials (Skill Builder)**](https://skillbuilder.aws/)
  Curso oficial gratuito. Si nunca has tocado AWS, estas cuatro horas te ahorran las cuatro sesiones del bloque.
- [**AWS CLI — User Guide**](https://docs.aws.amazon.com/cli/latest/userguide/)
  Instalación, `aws configure` y perfiles nombrados.

## IAM a fondo

- ★ [**IAM — User Guide**](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
  El servicio que más vale la pena entender bien. Si sólo dominas uno de AWS, que sea éste.
- [**IAM Policy Simulator**](https://policysim.aws.amazon.com/)
  Prueba qué permite y qué niega tu política **sin aplicarla**. Gratis, y casi nadie lo usa. Es obligatorio en el laboratorio.
- [**Referencia de políticas JSON**](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html)
  La gramática completa: Effect, Action, Resource, Condition y las claves de contexto.
- [**Acciones, recursos y claves de condición de S3**](https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazons3.html)
  Qué acciones existen y sobre qué ARN aplica cada una. Resuelve la trampa de `ListBucket` vs `GetObject`.
- [**IAM Access Analyzer**](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)
  Revisa lo que YA tienes y señala lo que está de más o expuesto hacia afuera.

## Credenciales sin filtraciones

- ★ [**boto3 — Credentials**](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html)
  El orden en que boto3 busca credenciales, y cómo pasarle un perfil. La respuesta a «¿dónde pongo la llave?» es: en ningún lado del código.
- [**gitleaks**](https://github.com/gitleaks/gitleaks)
  Detecta secretos en el repositorio y en el **historial**. Se corre en el laboratorio.
- [**Qué hacer si expusiste una llave de acceso**](https://repost.aws/knowledge-center/potential-account-compromise)
  La guía oficial. Resumen: rótala, no la borres, y revisa qué se hizo con ella.

## Costos

- ★ [**AWS Pricing Calculator**](https://calculator.aws/)
  Estima antes de gastar. Los precios cambian: ésta es la fuente, no las diapositivas.
- [**AWS Budgets**](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html)
  Configura la alerta el primer día. Dos minutos.
- [**AWS Free Tier**](https://aws.amazon.com/free/)
  Lee la letra chica: qué expira a los 12 meses, qué es «siempre gratis» hasta cierto límite, y qué se cobra en cuanto te pasas.
- [**Precios de S3**](https://aws.amazon.com/s3/pricing/)
  Almacenamiento, solicitudes y transferencia de salida, por separado. Las tres se cobran.

## Datos de salud: México y cumplimiento

- ★ [**Ley Federal de Protección de Datos Personales en Posesión de los Particulares (texto vigente)**](https://www.diputados.gob.mx/LeyesBiblio/pdf/LFPDPPP.pdf)
  **Ley nueva**, publicada en el DOF el 20 de marzo de 2025: abroga la de 2010. Lee el artículo 3 fracción VI (el estado de salud es dato sensible) y el artículo 8 (consentimiento expreso y por escrito).
- [**AWS HIPAA Compliance**](https://aws.amazon.com/compliance/hipaa-compliance/)
  Qué significa «servicio elegible para HIPAA» y qué implica firmar un BAA. Aplica a datos de EUA, no a los mexicanos; sirve para entender el modelo.
- [**AWS Well-Architected — pilar de seguridad**](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
  El marco con el que se revisan arquitecturas en la industria.
- [**AWS for Healthcare & Life Sciences**](https://aws.amazon.com/health/)
  Arquitecturas de referencia del sector.

## Práctica guiada

- ★ [**AWS Workshops**](https://workshops.aws/)
  Talleres prácticos gratuitos, paso a paso.
- [**AWS Global Infrastructure**](https://aws.amazon.com/about-aws/global-infrastructure/)
  Mapa de regiones y zonas de disponibilidad.

## Libro

- ★ [**Learning Amazon Web Services (Mark Wilkins)**](https://www.oreilly.com/library/view/learning-amazon-web/9780134800868/)
  Bibliografía base del curso.
