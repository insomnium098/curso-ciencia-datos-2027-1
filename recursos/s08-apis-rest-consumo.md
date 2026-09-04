# Material complementario — Sesión 08

## APIs REST: Consumo de Servicios Web con Python

*Bloque II — Ingeniería de software para científicos*

> Los recursos marcados con **★** son los que conviene revisar antes de la clase.
> El resto es para profundizar según tu interés y tu proyecto.

## Objetivos que apoya este material

- Explicar el modelo HTTP/REST: recursos, verbos, códigos de estado y encabezados
- Consumir APIs biomédicas públicas (PubMed, ClinicalTrials.gov, openFDA, FHIR) desde Python
- Manejar autenticación, paginación, rate limiting y errores de forma robusta
- Construir un cliente reutilizable con reintentos, backoff y caché

## Fundamentos HTTP

- ★ [**MDN — HTTP**](https://developer.mozilla.org/es/docs/Web/HTTP)
  La mejor referencia de HTTP, en español. Empieza por 'Overview' y 'Messages'.
- [**MDN — Códigos de estado HTTP**](https://developer.mozilla.org/es/docs/Web/HTTP/Status)
  Consulta rápida. El 429 es el que más te va a doler.
- [**MDN — Encabezado Retry-After**](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After)
  Lo que el servidor te pide esperar. Respetarlo es cortesía y también supervivencia.
- [**HTTP Cats**](https://http.cat/)
  Mnemotecnia felina de los códigos de estado. Funciona sorprendentemente bien.

## Librerías de Python

- ★ [**requests — Documentación**](https://requests.readthedocs.io/en/latest/)
  El cliente HTTP clásico. Lee 'Quickstart' y 'Advanced Usage' (sesiones y adaptadores).
- [**urllib3 — Retry**](https://urllib3.readthedocs.io/en/stable/reference/urllib3.util.html#urllib3.util.Retry)
  La política de reintentos que monta `requests` por debajo: backoff, status_forcelist, allowed_methods.
- [**HTTPX**](https://www.python-httpx.org/)
  Cliente moderno con HTTP/2 y soporte asíncrono. Misma API que requests.
- [**tenacity**](https://tenacity.readthedocs.io/)
  Reintentos declarativos con decoradores. Más expresivo que urllib3 cuando la lógica se complica.
- [**requests-cache**](https://requests-cache.readthedocs.io/)
  Caché transparente en disco. Te hace cortés y reproducible con una línea.
- [**Pydantic — Documentación**](https://docs.pydantic.dev/latest/)
  Validar en la frontera: la respuesta de la API es culpable hasta demostrar lo contrario.

## Probar sin red

- ★ [**responses**](https://github.com/getsentry/responses)
  Simula respuestas de `requests` en tus pruebas. Es lo que hace que `pytest` corra con el wifi apagado.
- [**RESPX**](https://lundberg.github.io/respx/)
  El equivalente para `httpx`.
- [**VCR.py**](https://vcrpy.readthedocs.io/)
  Graba las respuestas reales una vez y las reproduce después. Alternativa cuando simular a mano es tedioso.
- [**pytest — monkeypatch**](https://docs.pytest.org/en/stable/how-to/monkeypatch.html)
  Para sustituir variables de entorno y llaves de API en las pruebas.

## APIs biomédicas

- ★ [**NCBI E-utilities — Guía del desarrollador**](https://www.ncbi.nlm.nih.gov/books/NBK25501/)
  Documentación oficial de PubMed/GenBank. Léela antes de escribir código: la política de uso es explícita.
- [**NCBI — Obtener una API key**](https://support.nlm.nih.gov/kbArticle/?pn=KA-05317)
  Gratuita y sube tu límite de 3 a 10 peticiones por segundo.
- [**ClinicalTrials.gov API v2**](https://clinicaltrials.gov/data-api/api)
  API moderna con documentación interactiva. Sin llave.
- [**openFDA**](https://open.fda.gov/apis/)
  Eventos adversos, etiquetas, recalls y dispositivos. Sin llave para uso básico.
- [**RxNav API (NLM)**](https://lhncbc.nlm.nih.gov/RxNav/APIs/index.html)
  Interrogar RxNorm programáticamente. Insumo directo de la sesión 15.
- [**Europe PMC — REST API**](https://europepmc.org/RestfulWebService)
  Alternativa a PubMed, con texto completo abierto y sin llave.
- [**HL7 FHIR — Overview**](https://www.hl7.org/fhir/overview.html)
  El estándar con el que un hospital te entrega datos clínicos.
- [**HAPI FHIR — servidor público de pruebas**](https://hapi.fhir.org/)
  Servidor FHIR gratuito para practicar sin credenciales.

## Diseño, exploración y práctica

- ★ [**Public APIs (lista curada)**](https://github.com/public-apis/public-apis)
  Cientos de APIs abiertas para practicar.
- [**Postman Learning Center**](https://learning.postman.com/docs/introduction/overview/)
  Explorar una API antes de escribir código. Ahorra horas.
- [**HTTPie**](https://httpie.io/docs/cli)
  Cliente de terminal legible. Mejor que curl para inspeccionar JSON a ojo.
- [**jq**](https://jqlang.github.io/jq/manual/)
  Filtrar JSON desde la terminal. Imprescindible para explorar respuestas grandes.
- [**REST API Tutorial**](https://restfulapi.net/)
  Convenciones de diseño: recursos, versionado, códigos. Útil para la sesión 9.

## Cómo usar este material

1. **Antes de la clase:** revisa los recursos marcados con ★ (30–45 min).
2. **Durante el laboratorio:** ten abiertas las páginas de documentación oficial.
3. **Después:** elige un recurso de profundización relacionado con tu proyecto final.

