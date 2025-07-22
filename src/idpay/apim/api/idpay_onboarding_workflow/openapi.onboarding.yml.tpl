openapi: 3.0.1
info:
  title: IDPAY ITN Onboarding Workflow IO API
  description: IDPAY ITN Onboarding Workflow IO
  version: "1.0"
  contact:
    name: PagoPA S.p.A.
    email: cstar@pagopa.it
servers:
  - description: Development Test
    url: https://api-io.dev.cstar.pagopa.it/idpay-itn/onboarding
    x-internal: true
  - description: User Acceptance Test
    url: https://api-io.uat.cstar.pagopa.it/idpay-itn/onboarding
    x-internal: true
paths:
  /service/{serviceId}:
    get:
      tags:
        - onboarding
      summary: "ENG: Retrieves the initiative ID starting from the corresponding service ID - IT: Ritrova l'identificativo dell'iniziativa a partire dall'idetificativo del service"
      description: "Retrieves the initiative ID starting from the corresponding service ID"
      operationId: getInitiativeData
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - name: serviceId
          in: path
          description: "ENG: The service ID - IT: Identificativo del service"
          required: true
          schema:
            type: string
            maxLength: 50
            pattern: "$ ^[a-zA-Z0-9]+$"
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            pattern: "^[ -~]{2,5}$"
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
      responses:
        "200":
          description: Get successful
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/InitiativeDataDTO"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "400":
          description: Bad request
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/InitiativeErrorDTO"
              example:
                code: "INITIATIVE_INVALID_REQUEST"
                message: "Something went wrong handling the request"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "401":
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "404":
          description: The requested initiative was not found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/InitiativeErrorDTO"
              example:
                code: "INITIATIVE_NOT_FOUND"
                message: "Initiative not found"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "429":
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/InitiativeErrorDTO"
              example:
                code: "INITIATIVE_TOO_MANY_REQUESTS"
                message: "Too many requests"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "500":
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/InitiativeErrorDTO"
              example:
                code: "INITIATIVE_GENERIC_ERROR"
                message: "Application error"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"

  /:
    put:
      tags:
        - onboarding
      summary: "ENG: Acceptance of Terms & Conditions - IT: Accettazione dei Termini e condizioni"
      description: "Acceptance of Terms & Conditions"
      operationId: onboardingCitizen
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            pattern: "^[ -~]{2,5}$"
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
      requestBody:
        description: "ENG: Id of the initiative IT: Identificativo dell'iniziativa"
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/OnboardingPutDTO"
      responses:
        "204":
          description: Acceptance successful
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "400":
          description: Bad request
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "401":
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "403":
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_BUDGET_EXHAUSTED"
                message: "Budget exhausted for initiative XXXXX"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "404":
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_INITIATIVE_NOT_FOUND"
                message: "Cannot find initiative XXXXX"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "429":
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "500":
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
  /initiative:
    put:
      tags:
        - onboarding
      summary: "ENG: Checks the initiative prerequisites - IT: Verifica i prerequisiti dell'iniziativa"
      description: "Checks the initiative prerequisites"
      operationId: checkPrerequisites
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            pattern: "^[ -~]{2,5}$"
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
      requestBody:
        description: "ENG: Id of the initiative - IT: Identificatico dell'iniziativa"
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/OnboardingPutDTO"
      responses:
        "200":
          description: Check successful
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/RequiredCriteriaDTO"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "202":
          description: Accepted - Request Taken Over
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "400":
          description: Bad request
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "401":
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "403":
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_BUDGET_EXHAUSTED"
                message: "Budget exhausted for initiative XXXXX"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "404":
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_INITIATIVE_NOT_FOUND"
                message: "Cannot find initiative XXXXX"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "429":
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "500":
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
  /consent:
    put:
      tags:
        - onboarding
      summary: "ENG: Saves the consensus of both PDND and self-declaration - IT: Salva i consensi di PDND e le autodichiarazioni"
      description: "Saves the consensus of both PDND and self-declaration"
      operationId: consentOnboarding
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            pattern: "^[ -~]{2,5}$"
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
      requestBody:
        description: >-
          ENG: Unique identifier of the subscribed initiative, flag for PDND
          acceptation and the list of accepted self-declared criteria - IT: Identificativo univoco dell'iniziativa sottoscritta, flag per l'accettazione PDND e l'elenco dei criteri autodichiarati accettati
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/ConsentPutDTO"
      responses:
        "202":
          description: Accepted - Request Taken Over
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "400":
          description: Bad request
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "401":
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "403":
          description: This onboarding is forbidden
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_BUDGET_EXHAUSTED"
                message: "Budget exhausted for initiative XXXXX"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "404":
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_INITIATIVE_NOT_FOUND"
                message: "Cannot find initiative XXXXX"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "429":
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "500":
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
  "/{initiativeId}/status":
    get:
      tags:
        - onboarding
      summary: "ENG: Returns the actual onboarding status along with the date on which that status changed and, if present, the date upon which the onboarding successfully went through - IT: Ritorna lo stato attuale dell'adesione insieme alla data in cui quello stato è cambiato e, se presente, la data in cui l'adesione è avvenuta con successo"
      description: "Returns the actual onboarding status along with the date on which that status changed and, if present, the date upon which the onboarding successfully went through"
      operationId: onboardingStatus
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            pattern: "^[ -~]{2,5}$"
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
          required: true
          schema:
            type: string
            maxLength: 24
            pattern: "$ ^[a-zA-Z0-9]+$"
      responses:
        "200":
          description: Check successful
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingStatusDTO"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "400":
          description: Bad Request
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_INVALID_REQUEST"
                message: "Something went wrong handling the request"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "401":
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "404":
          description: The requested resource was not found
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_USER_NOT_ONBOARDED"
                message: "The current user is not onboarded on initiative XXXXX"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "429":
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_TOO_MANY_REQUESTS"
                message: "Too many requests"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "500":
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: "ONBOARDING_GENERIC_ERROR"
                message: "An error occurred in the microservice admissibility"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
  "/user/initiative/status":
    get:
      tags:
        - onboarding
      summary: >-
        ENG: Returns all initiatives in Waiting List or In Evaluation status that the user is onboarded to or has requested
        - IT: Ritorna tutte le iniziative in stato Lista Attesa o In Valutazione a cui l'utente è onboardato o che ha fatto richiesta
      description: "Returns all initiatives in Waiting List or In Evaluation status that the user is onboarded to or has requested"
      operationId: onboardingInitiativeUserStatus
      parameters:
        - $ref: "#/components/parameters/ApiVersionHeader"
        - name: Accept-Language
          in: header
          description: "ENG: Language - IT: Lingua"
          schema:
            type: string
            pattern: "^[ -~]{2,5}$"
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
      responses:
        "200":
          description: Check successful
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/ListOnboardingStatusDTO"
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "400":
          description: Bad Request
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: ONBOARDING_INVALID_REQUEST
                message: Something went wrong handling the request
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "401":
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "429":
          description: Too many Requests
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: ONBOARDING_TOO_MANY_REQUESTS
                message: Too many requests
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
        "500":
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/OnboardingErrorDTO"
              example:
                code: ONBOARDING_GENERIC_ERROR
                message: An error occurred in the microservice admissibility
          headers:
            Access-Control-Allow-Origin:
              $ref: "#/components/headers/Access-Control-Allow-Origin"
            RateLimit-Limit:
              $ref: "#/components/headers/RateLimit-Limit"
            RateLimit-Reset:
              $ref: "#/components/headers/RateLimit-Reset"
            Retry-After:
              $ref: "#/components/headers/Retry-After"
components:
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
  schemas:
    ConsentPutDTO:
      title: ConsentPutDTO
      type: object
      required:
        - initiativeId
        - pdndAccept
        - selfDeclarationList
      properties:
        initiativeId:
          type: string
          description: "ENG: Unique identifier of the subscribed initiative - IT: Identificativo univoco dell'iniziativa sottoscritta"
          maxLength: 24
          pattern: "$ ^[a-zA-Z0-9]+$"
        pdndAccept:
          type: boolean
          description: "ENG: Flag for PDND acceptation - IT: Flag per l'accettazione PDND"
        selfDeclarationList:
          type: array
          items:
            $ref: "#/components/schemas/SelfConsentDTO"
          description: "ENG: The list of accepted self-declared criteria - IT: Lista dei criteri autodichiarati"
          maxItems: 10
    SelfConsentDTO:
      oneOf:
        - $ref: "#/components/schemas/SelfConsentBoolDTO"
        - $ref: "#/components/schemas/SelfConsentMultiDTO"
        - $ref: "#/components/schemas/SelfConsentTextDTO"
    ListOnboardingStatusDTO:
      title: ListOnboardingStatusDTO
      type: array
      items:
        $ref: "#/components/schemas/UserOnboardingStatusDTO"
      description: >-
        ENG: List of initiatives in Waiting List or In Evaluation status, to which the user is onboarded
        - IT: Lista delle iniziative in stato Lista d''attesa o In Valutazione, a cui l'utente è onboardato
      maxItems: 10
    OnboardingPutDTO:
      title: OnboardingPutDTO
      type: object
      required:
        - initiativeId
      properties:
        initiativeId:
          type: string
          description: "ENG: Unique identifier of the subscribed initiative - IT: Identificativo univoco dell'iniziativa sottoscritta"
          maxLength: 24
          pattern: "$ ^[a-zA-Z0-9]+$"
    UserOnboardingStatusDTO:
      title: UserOnboardingStatusDTO
      type: object
      required:
        - initiativeName
        - serviceId
        - initiativeId
        - status
        - statusDate
      properties:
        initiativeName:
          type: string
          description: "ENG: Name of the initiative - IT: Nome dell'iniziativa"
          pattern: "^[ -~]{1,255}$"
          example: "Bonus Elettrodomestici"
          maxLength: 255
        serviceId:
          type: string
          description: "ENG: The service ID - IT: Identificativo del service"
          maxLength: 50
          pattern: "$ ^[a-zA-Z0-9]+$"
        initiativeId:
          type: string
          description: "ENG: Unique identifier of the subscribed initiative - IT: Identificativo univoco dell'iniziativa sottoscritta"
          maxLength: 24
          pattern: "$ ^[a-zA-Z0-9]+$"
        status:
          enum:
            - ACCEPTED_TC
            - ON_EVALUATION
            - ONBOARDING_KO
            - ELIGIBLE_KO
            - ONBOARDING_OK
            - UNSUBSCRIBED
            - INVITED
            - DEMANDED
            - SUSPENDED
          type: string
          description: "ENG: Actual status of the citizen onboarding for an initiative - IT: Stato attuale del cittadino rispetto ad un'iniziativa"
        statusDate:
          type: string
          format: date-time
          minLength: 19
          maxLength: 19
          description: "ENG: Date on which the status changed to the current one - IT: Data in cui lo stato è cambiato allo stato attuale"
        detailKo:
          enum:
            - ONBOARDING_FAMILY_UNIT_ALREADY_JOINED
            - ONBOARDING_WAITING_LIST
            - ONBOARDING_USER_UNSUBSCRIBED
            - ONBOARDING_PAGE_SIZE_NOT_ALLOWED
            - ONBOARDING_PDND_CONSENT_DENIED
            - ONBOARDING_SELF_DECLARATION_NOT_VALID
            - ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_INVALID_REQUEST
            - ONBOARDING_USER_NOT_IN_WHITELIST
            - ONBOARDING_INITIATIVE_NOT_STARTED
            - ONBOARDING_INITIATIVE_ENDED
            - ONBOARDING_BUDGET_EXHAUSTED
            - ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED
            - ONBOARDING_TECHNICAL_ERROR
            - ONBOARDING_UNSATISFIED_REQUIREMENTS
            - ONBOARDING_GENERIC_ERROR
            - ONBOARDING_USER_NOT_ONBOARDED
            - ONBOARDING_INITIATIVE_NOT_FOUND
            - ONBOARDING_TOO_MANY_REQUESTS
          type: string
          description: >-
            "ENG: Identify the detail of the ko status. - IT: Identifica il dettaglio dello status di ko"
    OnboardingStatusDTO:
      title: OnboardingStatusDTO
      type: object
      required:
        - status
        - statusDate
      properties:
        status:
          enum:
            - ACCEPTED_TC
            - ON_EVALUATION
            - ONBOARDING_KO
            - ELIGIBLE_KO
            - ONBOARDING_OK
            - UNSUBSCRIBED
            - INVITED
            - DEMANDED
            - SUSPENDED
          type: string
          description: "ENG: Actual status of the citizen onboarding for an initiative - IT: Stato attuale del cittadino rispetto ad un'iniziativa"
        statusDate:
          type: string
          format: date-time
          minLength: 19
          maxLength: 19
          description: "ENG: Date on which the status changed to the current one - IT: Data in cui lo stato è cambiato allo stato attuale"
        detailKo:
          enum:
            - ONBOARDING_FAMILY_UNIT_ALREADY_JOINED
            - ONBOARDING_WAITING_LIST
            - ONBOARDING_USER_UNSUBSCRIBED
            - ONBOARDING_PAGE_SIZE_NOT_ALLOWED
            - ONBOARDING_PDND_CONSENT_DENIED
            - ONBOARDING_SELF_DECLARATION_NOT_VALID
            - ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_INVALID_REQUEST
            - ONBOARDING_USER_NOT_IN_WHITELIST
            - ONBOARDING_INITIATIVE_NOT_STARTED
            - ONBOARDING_INITIATIVE_ENDED
            - ONBOARDING_BUDGET_EXHAUSTED
            - ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED
            - ONBOARDING_TECHNICAL_ERROR
            - ONBOARDING_UNSATISFIED_REQUIREMENTS
            - ONBOARDING_GENERIC_ERROR
            - ONBOARDING_USER_NOT_ONBOARDED
            - ONBOARDING_INITIATIVE_NOT_FOUND
            - ONBOARDING_TOO_MANY_REQUESTS
          type: string
          description: >-
            "ENG: Identify the detail of the ko status. - IT: Identifica il dettaglio dello status di ko"
        onboardingOkDate:
          type: string
          format: date-time
          minLength: 19
          maxLength: 19
          description: "ENG: Date on which the onboarding successfully went through - IT: Data in cui l'adesione è avvenuta con successo"
    RequiredCriteriaDTO:
      type: object
      required:
        - pdndCriteria
        - selfDeclarationList
      properties:
        pdndCriteria:
          type: array
          items:
            $ref: "#/components/schemas/PDNDCriteriaDTO"
          description: "ENG: The list of checks made on the PDND platform - IT: Lista dei controlli effettutati dalla piattaforma PDND"
          maxItems: 5
        selfDeclarationList:
          type: array
          items:
            $ref: "#/components/schemas/SelfDeclarationDTO"
          description: "ENG: The list of required self-declared criteria - IT: Lista dei criteri richiesti da autodichiarare"
          maxItems: 10
    SelfDeclarationDTO:
      oneOf:
        - $ref: "#/components/schemas/SelfDeclarationBoolDTO"
        - $ref: "#/components/schemas/SelfDeclarationMultiDTO"
        - $ref: "#/components/schemas/SelfDeclarationTextDTO"
    PDNDCriteriaDTO:
      type: object
      required:
        - code
        - description
        - value
        - authority
      properties:
        code:
          type: string
          enum:
            - ISEE
            - BIRTHDATE
            - RESIDENCE
            - FAMILY_UNIT
          description: "ENG: A code that identifies the type of criteria - IT: Codice che identifica il tipo di criterio"
        description:
          type: string
          description: "ENG: Description of the criteria - IT: Descrizione del criterio"
          maxLength: 255
          example: "descrizione del criterio"
          pattern: "^[ -~]{0,255}$"
        value:
          type: string
          description: >-
            "ENG: The expected value for the criteria. It is used in conjunction with
            the operator to define a range or an equality over that criteria. - IT: Valore atteso dal criterio. E' usato insieme al campo operator per definire un insieme di valori o un'uguaglianza con un valore"
          maxLength: 255
          example: "valore del criterio"
          pattern: "^[ -~]{0,255}$"
        value2:
          type: string
          description: >-
            "ENG: In situations where the operator expects two values (e.g BETWEEN)
            this field is populated - IT: Popolato quando il campo operator si aspetta due valori (e.g BETWEEN)"
          maxLength: 255
          example: "BETWEEN"
          pattern: "^[ -~]{0,255}$"
        operator:
          type: string
          description: "ENG: Represents the relation between the criteria and the value field - IT: Rappresenta la relazione tra il criterio ed il campo value"
          enum:
            - EQ
            - NOT_EQ
            - LT
            - LE
            - GT
            - GE
            - BTW_CLOSED
            - BTW_OPEN
        authority:
          type: string
          description: "ENG: Authority to request PDND criteria value - IT: Autorità a cui richiedere il valore dei criteri PDND"
          enum:
            - INPS
            - AGID
    SelfDeclarationBoolDTO:
      type: object
      required:
        - _type
        - code
        - description
        - value
      properties:
        _type:
          type: string
          description: "ENG: Self-declaration boolean type - IT: Autodichiarazione di tipo boolean"
          enum:
            - boolean
        code:
          type: string
          description: "ENG: Self-declaration code - IT: Codice dell'autodichiarazione"
          maxLength: 10
          pattern: "^[ -~]{1,10}$"
        description:
          type: string
          example: "descrizione"
          description: "ENG: Self-declaration description - IT: Descrizione dell'autodichiarazione"
          maxLength: 255
          pattern: "^[ -~]{0,255}$"
        subDescription:
          type: string
          example: "sotto descrizione"
          description: >-
            ENG: Self-declaration sub-description - IT: Sotto descrizione
            dell'autodichiarazione
          maxLength: 255
          pattern: "^[ -~]{0,255}$"
        value:
          type: boolean
          description: "ENG: Indicates whether the self-declaration is accepted or not - IT: Indica se l'autodichiarazione è accettata o no"
    SelfDeclarationMultiDTO:
      type: object
      required:
        - _type
        - code
        - description
        - value
      properties:
        _type:
          type: string
          description: "ENG: Self-declaration value type - IT: Autodichiarazione di tipo multipli"
          enum:
            - multi
        code:
          type: string
          description: "ENG: Self-declaration code - IT: Codice dell'autodichiarazione"
          maxLength: 10
          pattern: "^[ -~]{1,10}$"
        description:
          type: string
          example: "descrizione"
          description: "ENG: Self-declaration description - IT: Descrizione dell'autodichiarazione"
          maxLength: 255
          pattern: "^[ -~]{0,255}$"
        subDescription:
          type: string
          example: "sotto descrizione"
          description: >-
            ENG: Self-declaration sub-description - IT: Sotto descrizione
            dell'autodichiarazione
          maxLength: 255
          pattern: "^[ -~]{0,255}$"
        value:
          type: array
          items:
            $ref: "#/components/schemas/RowDataDTO"
          description: >-
            ENG: Indicates self-declaration values - IT: Indica i valori per
            l'autodichiarazione
          maxItems: 10
    RowDataDTO:
      type: object
      required:
        - description
      properties:
        description:
          type: string
          example: "descrizione"
          description: >-
            ENG: Self-declaration description - IT: Descrizione
            del record di autodichiarazione
          pattern: "^[ -~]{0,250}$"
          maxLength: 250
        subDescription:
          type: string
          example: "sotto descrizione"
          description: >-
            ENG: Self-declaration sub-description - IT: Sotto descrizione
            del record di autodichiarazione
          maxLength: 255
          pattern: "^[ -~]{0,255}$"
    SelfDeclarationTextDTO:
      type: object
      required:
        - _type
        - code
        - description
        - value
      properties:
        _type:
          type: string
          description: >-
            ENG: Self-declaration value type free text - IT: Autodichiarazione di tipo
            testo libero
          enum:
            - text
        code:
          type: string
          description: "ENG: Self-declaration code - IT: Codice dell'autodichiarazione"
          maxLength: 10
          pattern: "^[ -~]{1,10}$"
        description:
          type: string
          example: "descrizione"
          description: >-
            ENG: Self-declaration description - IT: Descrizione
            dell'autodichiarazione
          maxLength: 255
          pattern: "^[ -~]{0,255}$"
        subDescription:
          type: string
          example: "sotto descrizione"
          description: >-
            ENG: Self-declaration sub-description - IT: Sotto descrizione
            dell'autodichiarazione
          maxLength: 255
          pattern: "^[ -~]{0,255}$"
        value:
          type: string
          description: >-
            ENG: Indicates self-declaration values - IT: Indica i valori per
            l'autodichiarazione
          pattern: "^[ -~]{0,250}$"
          maxLength: 250
    SelfConsentBoolDTO:
      type: object
      required:
        - _type
        - code
        - accepted
      properties:
        _type:
          type: string
          enum:
            - boolean
          description: "ENG: Self-consent boolean type - IT: Auto consenso di tipo boolean"
        code:
          type: string
          description: "ENG: Self-consent code - IT: Codice dell'auto consenso"
          maxLength: 10
          pattern: "^[ -~]{1,10}$"
        accepted:
          type: boolean
          description: "ENG: Indicates whether the self-consent is accepted or not - IT: Indica se l'auto consenso è accettato o no"
    SelfConsentMultiDTO:
      type: object
      required:
        - _type
        - code
        - value
      properties:
        _type:
          type: string
          enum:
            - multi
          description: "ENG: Self-consent value type - IT: Auto consenso di tipo multipli"
        code:
          type: string
          description: "ENG: Self-consent code - IT: Codice dell'auto consenso"
          pattern: "^[ -~]{0,10}$"
          maxLength: 10
        value:
          type: string
          example: "0, 1"
          description: "ENG: Indicates self-consent values - IT: Indica i valori per gli auto consensi"
          pattern: "^[ -~]{0,10}$"
          maxLength: 10
    SelfConsentTextDTO:
      type: object
      required:
        - _type
        - code
        - value
      properties:
        _type:
          type: string
          enum:
            - text
          description: "ENG: Self-consent value type free text - IT: Auto consenso di tipo testo libero"
        code:
          type: string
          description: "ENG: Self-consent code - IT: Codice dell'auto consenso"
          pattern: "^[ -~]{0,10}$"
          maxLength: 10
        value:
          type: string
          description: >-
            ENG: Indicates self-consent values - IT: Indica i valori per gli
            auto consensi
          pattern: "^[ -~]{0,255}$"
          maxLength: 255
    InitiativeDataDTO:
      type: object
      required:
        - initiativeId
        - initiativeName
        - description
        - links
        - organizationId
        - organizationName
        - tcLink
        - privacyLink
      properties:
        initiativeId:
          type: string
          description: "ENG: The initiative ID - IT: Identificativo dell'iniziativa"
          maxLength: 24
          pattern: "$ ^[a-zA-Z0-9]+$"
        initiativeName:
          type: string
          description: "ENG: Initiative's name - IT: Nome dell'iniziativa"
          pattern: "^[ -~]{1,255}$"
          example: "Bonus Elettrodomestici"
          maxLength: 255
        description:
          type: string
          example: "Descrizione dell'iniziativa"
          description: "ENG: Initiative's description - IT: Descrizione dell'iniziativa"
          pattern: "^[ -~]{1,255}$"
          maxLength: 255
        links:
          type: array
          items:
            $ref: "#/components/schemas/LinkDTO"
          maxItems: 10
        organizationId:
          type: string
          description: "ENG: Id of the organization that created the initiative - IT: Identificativo dell'organizzazione che ha creato l'iniziativa"
          pattern: "^[ -~]{1,50}$"
          maxLength: 50
        organizationName:
          type: string
          description: "ENG: Name of the organization that created the initiative - IT: Nome dell'organizzazione che ha creato l'iniziativa"
          pattern: "^[ -~]{1,50}$"
          maxLength: 50
        tcLink:
          type: string
          description: "ENG: URL that redirects to the terms and conditions - IT: URL che porta ai termini e condizioni"
          pattern: "^(https):\\/\\/[a-zA-Z0-9.-]+(:[0-9]+)?(\\/[a-zA-Z0-9._~!$&'()*+,;=:@%-]*)*(\\?[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?(#[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?$"
          maxLength: 255
        privacyLink:
          type: string
          description: "ENG: URL that redirects to the privacy policy - IT: URL che reindirizza all'informativa della privacy"
          pattern: "^(https):\\/\\/[a-zA-Z0-9.-]+(:[0-9]+)?(\\/[a-zA-Z0-9._~!$&'()*+,;=:@%-]*)*(\\?[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?(#[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?$"
          maxLength: 255
        logoURL:
          type: string
          description: "ENG: URL for the initiative's logo image - IT: URL del logo dell'iniziativa"
          pattern: "^(https):\\/\\/[a-zA-Z0-9.-]+(:[0-9]+)?(\\/[a-zA-Z0-9._~!$&'()*+,;=:@%-]*)*(\\?[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?(#[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?$"
          maxLength: 255
    LinkDTO:
      type: object
      required:
        - description
        - url
      properties:
        description:
          type: string
          enum:
            - MERCHANT
            - PRODUCT
          description: "ENG: Link's description - IT: Descrizione del tipo di link"
        url:
          type: string
          description: "ENG: Url's link - IT: Url del link"
          pattern: "^(https):\\/\\/[a-zA-Z0-9.-]+(:[0-9]+)?(\\/[a-zA-Z0-9._~!$&'()*+,;=:@%-]*)*(\\?[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?(#[a-zA-Z0-9._~!$&'()*+,;=:@%/?-]*)?$"
          minLength: 0
          maxLength: 255
    InitiativeErrorDTO:
      type: object
      properties:
        code:
          type: string
          enum:
            - INITIATIVE_INVALID_LOCALE_FORMAT
            - INITIATIVE_INVALID_REQUEST
            - INITIATIVE_NOT_FOUND
            - INITIATIVE_TOO_MANY_REQUESTS
            - INITIATIVE_GENERIC_ERROR
          description: >-
            "ENG: Error code:
             INITIATIVE_INVALID_LOCALE_FORMAT: Initiative not found due to invalid locale format,
             INITIATIVE_INVALID_REQUEST: Something went wrong handling the request,
             INITIATIVE_NOT_FOUND: Initiative not found,
             INITIATIVE_TOO_MANY_REQUESTS: Too many requests,
             INITIATIVE_GENERIC_ERROR: Application error,
             - IT: Codice di errore:
             INITIATIVE_INVALID_LOCALE_FORMAT: Iniziativa non trovata a causa di format locale non valido,
             INITIATIVE_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
             INITIATIVE_NOT_FOUND: Iniziativa non trovata,
             INITIATIVE_TOO_MANY_REQUESTS: Troppe richieste,
             INITIATIVE_GENERIC_ERROR: Errore generico"
        message:
          type: string
          description: "ENG: Error message - IT: Messaggio di errore"
          maxLength: 250
          pattern: "^[\\w\\s.,!?'\"-]+$"
    OnboardingErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - ONBOARDING_USER_UNSUBSCRIBED
            - ONBOARDING_PAGE_SIZE_NOT_ALLOWED
            - ONBOARDING_PDND_CONSENT_DENIED
            - ONBOARDING_SELF_DECLARATION_NOT_VALID
            - ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS
            - ONBOARDING_INVALID_REQUEST
            - ONBOARDING_USER_NOT_IN_WHITELIST
            - ONBOARDING_INITIATIVE_NOT_STARTED
            - ONBOARDING_INITIATIVE_ENDED
            - ONBOARDING_BUDGET_EXHAUSTED
            - ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED
            - ONBOARDING_TECHNICAL_ERROR
            - ONBOARDING_UNSATISFIED_REQUIREMENTS
            - ONBOARDING_GENERIC_ERROR
            - ONBOARDING_USER_NOT_ONBOARDED
            - ONBOARDING_INITIATIVE_NOT_FOUND
            - ONBOARDING_TOO_MANY_REQUESTS
            - ONBOARDING_FAMILY_UNIT_ALREADY_JOINED
            - ONBOARDING_WAITING_LIST
          description: >-
            "ENG: Error code:
            ONBOARDING_USER_UNSUBSCRIBED: The user has unsubscribed from initiative,
            ONBOARDING_PAGE_SIZE_NOT_ALLOWED: Page size not allowed,
            ONBOARDING_PDND_CONSENT_DENIED: The PDND consent was denied by the user for the initiative,
            ONBOARDING_SELF_DECLARATION_NOT_VALID: The self-declaration criteria are not
            valid for the initiative or those inserted by the user do not match those required by the initiative,
            ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS: It is not possible to suspend
            the user on initiative,
            ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS: It is not possible to readmit the user on initiative,
            ONBOARDING_INVALID_REQUEST: Something went wrong handling the request,
            ONBOARDING_USER_NOT_IN_WHITELIST: The current user is not allowed to participate to the initiative,
            ONBOARDING_INITIATIVE_NOT_STARTED: The initiative has not yet begun,
            ONBOARDING_INITIATIVE_ENDED: The initiative ended,
            ONBOARDING_BUDGET_EXHAUSTED: Budget exhausted for initiative,
            ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED: The initiative is not active,
            ONBOARDING_TECHNICAL_ERROR: A technical error occurred during the onboarding process,
            ONBOARDING_UNSATISFIED_REQUIREMENTS: The user does not satisfy the requirements set for the initiative,
            ONBOARDING_GENERIC_ERROR: Application error,
            ONBOARDING_USER_NOT_ONBOARDED: The current user is not onboarded on initiative,
            ONBOARDING_INITIATIVE_NOT_FOUND: Cannot find initiative,
            ONBOARDING_TOO_MANY_REQUESTS: Too many requests
            - IT: Codice di errore:
            ONBOARDING_USER_UNSUBSCRIBED: L'utente si è disiscritto dall'iniziativa,
            ONBOARDING_PAGE_SIZE_NOT_ALLOWED: Dimensione pagina non permessa,
            ONBOARDING_PDND_CONSENT_DENIED: Il consenso PDND per l'iniziativa è stato negato dall'utente,
            ONBOARDING_SELF_DECLARATION_NOT_VALID: I criteri di autodichiarazione non sono
            validi per l'iniziativa o quelli inseriti dall'utente
            non corrispondono con quelli richiesti dall'iniziativa,
            ONBOARDING_SUSPENSION_NOT_ALLOWED_FOR_USER_STATUS: Non è possibile sospendere
            l'utente dall'iniziativa,
            ONBOARDING_READMISSION_NOT_ALLOWED_FOR_USER_STATUS: Non è possibile riammettere l'utente all'iniziativa,
            ONBOARDING_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
            ONBOARDING_USER_NOT_IN_WHITELIST: L'utente corrente non ha il permesso di partecipare all'iniziativa,
            ONBOARDING_INITIATIVE_NOT_STARTED: L'iniziativa non è ancora partita,
            ONBOARDING_INITIATIVE_ENDED: L'iniziativa è terminata,
            ONBOARDING_BUDGET_EXHAUSTED: Il budget dell'iniziativa è esaurito,
            ONBOARDING_INITIATIVE_STATUS_NOT_PUBLISHED: L'iniziativa non è attiva,
            ONBOARDING_TECHNICAL_ERROR: Si è verificato un errore tecnico durante il processo di adesione,
            ONBOARDING_UNSATISFIED_REQUIREMENTS: L'utente non soddisfa i requisiti che sono stati richiesti per l'iniziativa,
            ONBOARDING_GENERIC_ERROR: Errore applicativo,
            ONBOARDING_USER_NOT_ONBOARDED: Utente non onboardato all'iniziativa,
            ONBOARDING_INITIATIVE_NOT_FOUND: Iniziativa non trovata,
            ONBOARDING_TOO_MANY_REQUESTS: Troppe richieste"
        message:
          type: string
          description: "ENG: Error message- IT: Messaggio di errore"
          maxLength: 250
          pattern: "^[\\w\\s.,!?'\"-]+$"
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: []
tags:
  - name: onboarding
    description: ""
