# Material complementario — Sesión 20

## Amazon S3: Almacenamiento de Datos Clínicos con boto3

*Bloque IV — Cómputo en la nube*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Diseñar una organización de buckets y prefijos adecuada para un proyecto de datos clínicos
- Operar S3 desde la CLI y desde Python con boto3
- Aplicar cifrado, versionado, control de acceso y ciclo de vida
- Leer datos directamente desde S3 con pandas y con formatos columnares

## Empieza por aquí

- ★ [**S3 — Security best practices**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)
  La checklist oficial. Los cuatro interruptores de la sesión salen de aquí.
- [**boto3 — S3 examples**](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-examples.html)
  Recetas listas. Léelas antes de escribir tu módulo, no después.
- [**Apache Parquet — documentación**](https://parquet.apache.org/docs/)
  Por qué es el formato estándar de analítica. La sección de formato de archivo explica lo columnar.

## S3 por dentro

- ★ [**Amazon S3 — User Guide**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)
  La referencia completa.
- [**Organizar objetos con prefijos**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-prefixes.html)
  La explicación oficial de que las carpetas no existen.
- [**Versionado de objetos**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
  Incluye qué es un *delete marker*, que es lo que vas a demostrar en el laboratorio.
- [**Reglas de ciclo de vida**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)
  Mover y expirar objetos solos. Úsalo también para expirar versiones viejas.
- [**URLs prefirmadas (presigned)**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ShareObjectPreSignedURL.html)
  Compartir un objeto con alguien de fuera, por tiempo limitado y sin darle credenciales.
- [**Cifrado del lado del servidor**](https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html)
  SSE-S3, SSE-KMS y cuándo justifica el costo extra de KMS.

## boto3

- ★ [**boto3 — documentación**](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
  El SDK de Python para AWS.
- [**boto3 — Paginadores**](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/paginators.html)
  **La trampa de los 1 000 objetos** y cómo se resuelve bien. Es la actividad 5 del laboratorio.
- [**boto3 — Manejo de errores**](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/error-handling.html)
  Cómo leer el código dentro de `ClientError` en vez de sólo el mensaje.
- [**Configuración de transferencias (multiparte)**](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-transfer.html)
  `TransferConfig` para archivos grandes. `upload_file` ya lo hace solo; esto es para afinarlo.

## Leer sin descargar

- ★ [**s3fs**](https://s3fs.readthedocs.io/)
  El sistema de archivos que deja a pandas leer `s3://…` directamente.
- [**DuckDB — leer desde S3**](https://duckdb.org/docs/current/core_extensions/httpfs/s3api.html)
  SQL sobre Parquet en S3, sin montar nada. Probablemente la opción que más te sirva en la tesis.
- [**AWS Athena**](https://docs.aws.amazon.com/athena/latest/ug/what-is.html)
  SQL *serverless* sobre S3. Cobra por TB escaneado: sin particiones escanea todo.
- [**Particionado y rendimiento en Athena**](https://docs.aws.amazon.com/athena/latest/ug/partitions.html)
  Por qué el formato `anio=2026/mes=03/` no es decorativo.

## Datos públicos

- ★ [**Registry of Open Data on AWS**](https://registry.opendata.aws/)
  Conjuntos públicos que **ya viven en S3**: puedes leerlos desde tu cuenta sin descargarlos.
- [**Open Data — ciencias de la vida**](https://registry.opendata.aws/tag/life-sciences/)
  Genómica, imagen y más. Buen punto de partida para el proyecto final.

## Costos y arquitectura

- ★ [**S3 Pricing**](https://aws.amazon.com/s3/pricing/)
  Lee especialmente el costo de transferencia de salida.
- [**S3 Storage Classes**](https://aws.amazon.com/s3/storage-classes/)
  Comparativa y casos de uso.
- [**AWS — Data Lake architecture**](https://docs.aws.amazon.com/whitepapers/latest/building-data-lakes/building-data-lake-aws.html)
  Whitepaper oficial.


