openapi: 3.0.1
info:
  title: IDPAY ITN Iban IO API
  description: IDPAY ITN IBAN IO
  version: "1.0"
  contact:
    name: PagoPA S.p.A.
    email: cstar@pagopa.it
servers:
  - description: Development Test
    url: https://api-io.dev.cstar.pagopa.it/idpay-itn/iban
    x-internal: true
  - description: User Acceptance Test
    url: https://api-io.uat.cstar.pagopa.it/idpay-itn/iban
    x-internal: true
paths:

  "/{iban}":
    get:
      tags:
        - iban
      summary: "ENG: Returns the details of the IBAN associated to the initiative by the citizen - IT: Ritorna i dettagli di un IBAN associato ad una iniziativa"
      description: "Returns the details of the IBAN associated to the initiative by the citizen"
      operationId: getIban
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - $ref: "#/components/parameters/AcceptLanguage"
        - $ref: "#/components/parameters/Iban"
      responses:
        "200":
          $ref: "#/components/responses/IbanDataResponse"
        "400":
          $ref: "#/components/responses/IbanBadRequestResponse"
        "401":
          $ref: "#/components/responses/IbanUnauthorizedResponse"
        "404":
          $ref: "#/components/responses/IbanNotFoundResponse"
        "429":
          $ref: "#/components/responses/IbanTooManyRequestsResponse"
        "500":
          $ref: "#/components/responses/IbanInternalServerErrorResponse"

  "/":
    get:
      tags:
        - iban
      summary: "ENG: Returns the list of IBAN associated to the citizen - IT: Ritorna la lista di IBAN associati ad un cittadino"
      description: "Returns the list of IBAN associated to the citizen"
      operationId: getIbanList
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - $ref: "#/components/parameters/AcceptLanguage"
      responses:
        "200":
          $ref: "#/components/responses/IbanListDataResponse"
        "400":
          $ref: "#/components/responses/IbanBadRequestResponse"
        "401":
          $ref: "#/components/responses/IbanUnauthorizedResponse"
        "429":
          $ref: "#/components/responses/IbanTooManyRequestsResponse"
        "500":
          $ref: "#/components/responses/IbanInternalServerErrorResponse"

components:

  headers:

    Access-Control-Allow-Origin:
      description: Indicates whether the response can be shared with requesting code from the given origin
      schema:
        type: string
        pattern: "^[ -~]{1,2048}$"
        minLength: 1
        maxLength: 2048

    RateLimit-Limit:
      description: The number of allowed requests in the current period
      schema:
        type: integer
        format: int32
        minimum: 1
        maximum: 240

    RateLimit-Reset:
      description: The number of seconds left in the current period
      schema:
        type: integer
        format: int32
        minimum: 1
        maximum: 60

    Retry-After:
      description: The number of seconds to wait before allowing a follow-up request
      schema:
        type: integer
        format: int32
        minimum: 1
        maximum: 240

  parameters:

    ApiVersionHeader:
      name: X-Api-Version
      in: header
      description: "ENG: Api Version - IT: Versione dell Api"
      required: true
      schema:
        type: string
        enum: [v1]
        example: v1
        default: v1

    Iban:
      name: iban
      in: path
      description: "ENG: The citizen IBAN - IT: IBAN del cittadino"
      required: true
      schema:
        type: string
        pattern: "^IT[0-9]{2}[A-Z]{1}[0-9]{5}[0-9]{5}[A-Z0-9]{12}$"
        minLength: 27
        maxLength: 27

    AcceptLanguage:
      name: Accept-Language
      in: header
      description: "ENG: Language - IT: Lingua"
      required: true
      schema:
        type: string
        pattern: "^[ -~]{2,5}$"
        minLength: 2
        maxLength: 5
        example: it-IT
        default: it-IT

  responses:

    IbanDataResponse:
      description: Ok
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/IbanDTO"
      headers: &StandardHeaders
        Access-Control-Allow-Origin:
          $ref: "#/components/headers/Access-Control-Allow-Origin"
        RateLimit-Limit:
          $ref: "#/components/headers/RateLimit-Limit"
        RateLimit-Reset:
          $ref: "#/components/headers/RateLimit-Reset"
        Retry-After:
          $ref: "#/components/headers/Retry-After"

    IbanBadRequestResponse:
      description: Bad request
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/IbanErrorDTO"
          example:
            code: "IBAN_INVALID_REQUEST"
            message: "Invalid request"
      headers: *StandardHeaders

    IbanUnauthorizedResponse:
      description: Authentication failed
      content: {}
      headers: *StandardHeaders

    IbanNotFoundResponse:
      description: The requested ID was not found
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/IbanErrorDTO"
          example:
            code: "IBAN_NOT_FOUND"
            message: "Iban not found"
      headers: *StandardHeaders

    IbanTooManyRequestsResponse:
      description: Too many requests
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/IbanErrorDTO"
          example:
            code: "IBAN_TOO_MANY_REQUESTS"
            message: "Too many requests"
      headers: *StandardHeaders

    IbanInternalServerErrorResponse:
      description: Server ERROR
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/IbanErrorDTO"
          example:
            code: "IBAN_GENERIC_ERROR"
            message: "Application error"
      headers: *StandardHeaders

    IbanListDataResponse:
      description: Ok
      content:
        application/json:
          schema:
            $ref: "#/components/schemas/IbanListDTO"
      headers: *StandardHeaders

  schemas:

    IbanDTO:
      type: object
      required:
        - iban
        - checkIbanStatus
        - description
        - channel
      properties:
        iban:
          type: string
          description: "ENG: IBAN of the citizen - IT: IBAN del cittadino"
          pattern: "^IT[0-9]{2}[A-Z]{1}[0-9]{5}[0-9]{5}[A-Z0-9]{12}$"
          minLength: 27
          maxLength: 27
        checkIbanStatus:
          type: string
          description: "ENG: Status of checkIban - IT: Stato del checkIban"
          enum: [OK, KO, UNKNOWN_PSP]
        holderBank:
          type: string
          description: "ENG: Holder Bank name - IT: Nome della banca"
          pattern: "^[a-zA-Z0-9_]+$"
          maxLength: 100
        description:
          type: string
          description: "ENG: General description associated with the iban - IT: Descrizione generale associata alll'IBAN"
          pattern: "^[a-zA-Z0-9_]+$"
          maxLength: 255
        channel:
          type: string
          description: "ENG: Channel from which the IBAN has been inserted - IT: Canale da cui l'IBAN è stato inserito"
          pattern: "^[a-zA-Z0-9_]+$"
          maxLength: 50

    IbanListDTO:
      type: object
      required:
        - ibanList
      properties:
        ibanList:
          type: array
          minItems: 0
          maxItems: 50
          items:
            $ref: "#/components/schemas/IbanDTO"
          description: "ENG: The list of IBAN associated to a citizen - IT: Lista di IBAN associati ad un cittadino"

    IbanErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - IBAN_NOT_FOUND
            - IBAN_INVALID_REQUEST
            - IBAN_TOO_MANY_REQUESTS
            - IBAN_GENERIC_ERROR
          description: >-
            "ENG: Error code: IBAN_NOT_FOUND: Iban not found,
             IBAN_INVALID_REQUEST: Something went wrong handling request,
             IBAN_TOO_MANY_REQUESTS: Too many requests,
             IBAN_GENERIC_ERROR: Application Error - IT: Codice di errore:
             IBAN_NOT_FOUND: Iban non trovato,
             IBAN_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
             IBAN_TOO_MANY_REQUESTS: Troppe richieste,
             IBAN_GENERIC_ERROR: Errore generico"
        message:
          type: string
          description: "ENG: Error message - IT: Messaggio di errore"
          maxLength: 2500
          pattern: '^[a-zA-Z0-9 _@\-.!?]+'

  securitySchemes:

    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: []
tags:
  - name: iban
    description: ""
