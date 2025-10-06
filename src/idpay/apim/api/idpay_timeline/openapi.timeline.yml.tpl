openapi: 3.0.1
info:
  title: IDPAY ITN Timeline IO API v2
  description: IDPAY ITN Timeline IO
  version: '2.0'
  contact:
    name: PagoPA S.p.A.
    email: cstar@pagopa.it
servers:
  - description: Development Test
    url: https://api-io.dev.cstar.pagopa.it/idpay-itn/timeline
    x-internal: true
  - description: User Acceptance Test
    url: https://api-io.uat.cstar.pagopa.it/idpay-itn/timeline
    x-internal: true
paths:
  '/{initiativeId}':
    get:
      tags:
        - timeline
      summary: >-
          ENG: Returns the list of transactions and operations of an initiative of a
          citizen sorted by date (newest->oldest) - IT: Ritorna la lista ordinata di transazioni e operazioni di una iniziativa di un cittadino (nuove->vecchie)
      description: Returns the list of transactions and operations of an initiative of a citizen sorted by date (newest->oldest)
      operationId: getTimeline
      parameters:
        - $ref: '#/components/parameters/ApiVersionHeader'
        - name: Accept-Language
          in: header
          description: 'ENG: Language - IT: Lingua'
          schema:
            type: string
            pattern: '^[ -~]{2,5}$'
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          in: path
          description: 'ENG: The initiative ID - IT: Identificativo dell''iniziativa'
          required: true
          schema:
            type: string
            maxLength: 24
            pattern: '^[a-zA-Z0-9]+$'
        - name: operationType
          in: query
          description: 'ENG: Operation type filter - IT: Filtro tipologia dell''operazione'
          schema:
            type: string
            maxLength: 24
            pattern: '^[a-zA-Z0-9]+$'
        - name: page
          in: query
          description: 'ENG: The number of the page - IT: Numero della pagina'
          schema:
            type: integer
            format: int32
            minimum: 0
            maximum: 240
        - name: size
          in: query
          description: 'ENG: Number of items, default 3 - max 10 - IT: Numero di elementi, default 3 - max 10'
          schema:
            type: integer
            format: int32
            minimum: 3
            maximum: 10
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineDTO'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_INVALID_REQUEST'
                message: 'Something went wrong handling request'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '401':
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_USER_NOT_FOUND'
                message: 'Timeline for the current user not found'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_TOO_MANY_REQUESTS'
                message: 'Too many requests'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_GENERIC_ERROR'
                message: 'Application error'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
  '/{initiativeId}/{operationId}':
    get:
      tags:
        - timeline
      summary: 'ENG: Returns the detail of a transaction - IT: Ritorna il dettaglio di una transazione'
      description: 'Returns the detail of a transaction'
      operationId: getTimelineDetail
      parameters:
        - $ref: '#/components/parameters/ApiVersionHeader'
        - name: Accept-Language
          description: 'ENG: Language - IT: Lingua'
          in: header
          schema:
            type: string
            pattern: '^[ -~]{2,5}$'
            minLength: 2
            maxLength: 5
            example: it-IT
            default: it-IT
          required: true
        - name: initiativeId
          description: 'ENG: The initiative ID - IT: Identificativo dell''iniziativa'
          in: path
          required: true
          schema:
            type: string
            maxLength: 24
            pattern: '^[a-zA-Z0-9]+$'
        - name: operationId
          description: 'ENG: The operation ID - IT: Identificativo dell''operazione'
          in: path
          required: true
          schema:
            type: string
            maxLength: 24
            pattern: '^[a-zA-Z0-9]+$'
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OperationDTO'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '400':
          description: Bad request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_INVALID_REQUEST'
                message: 'Something went wrong handling request'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '401':
          description: Authentication failed
          content:
            application/json: {}
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '404':
          description: The requested ID was not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_DETAIL_NOT_FOUND'
                message: 'Detail of Timeline not found'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '429':
          description: Too many Request
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_TOO_MANY_REQUESTS'
                message: 'Too many requests'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
        '500':
          description: Server ERROR
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TimelineErrorDTO'
              example:
                code: 'TIMELINE_GENERIC_ERROR'
                message: 'Application error'
          headers:
            Access-Control-Allow-Origin:
              $ref: '#/components/headers/Access-Control-Allow-Origin'
            RateLimit-Limit:
              $ref: '#/components/headers/RateLimit-Limit'
            RateLimit-Reset:
              $ref: '#/components/headers/RateLimit-Reset'
            Retry-After:
              $ref: '#/components/headers/Retry-After'
components:
  parameters:
    ApiVersionHeader:
      name: X-Api-Version
      in: header
      description: 'ENG: Api Version - IT: Versione dell Api'
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
        pattern: '^[ -~]{1,2048}$'
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
    OperationDTO:
      oneOf:
        - $ref: '#/components/schemas/TransactionDetailDTO'
        - $ref: '#/components/schemas/InstrumentOperationDTO'
        - $ref: '#/components/schemas/IbanOperationDTO'
        - $ref: '#/components/schemas/OnboardingOperationDTO'
        - $ref: '#/components/schemas/RefundDetailDTO'
        - $ref: '#/components/schemas/SuspendOperationDTO'
        - $ref: '#/components/schemas/ReadmittedOperationDTO'
        - $ref: '#/components/schemas/UnsubscribeOperationDTO'
    TimelineDTO:
      type: object
      required:
        - lastUpdate
        - operationList
        - pageNo
        - pageSize
        - totalElements
        - totalPages
      properties:
        lastUpdate:
          type: string
          description: 'ENG: Date of the last update - IT: Data dell''ultimo aggiornamento'
          format: date-time
        operationList:
          type: array
          minItems: 1
          maxItems: 10
          items:
            $ref: '#/components/schemas/OperationListDTO'
          description: 'ENG: The list of transactions and operations of an initiative of a citizen - IT: La lista di transazioni e operazioni di una iniziativa di un cittadino'
        pageNo:
          type: integer
          format: int32
          minimum: 0
          maximum: 200
          description: 'ENG: Number of pages - IT: Numero di pagine'
        pageSize:
          type: integer
          format: int32
          minimum: 0
          maximum: 50
          description: 'ENG: Number of elements in the page - IT: Numero di elementi all''interno della pagina'
        totalElements:
          type: integer
          format: int32
          minimum: 0
          maximum: 10
          description: 'ENG: Number of total elements - IT: Numero totali di elementi'
        totalPages:
          type: integer
          format: int32
          minimum: 0
          maximum: 200
          description: 'ENG: Number of total pages - IT: Numero totali di pagine'
    OperationListDTO:
      description: Complex type for items in the operation list
      oneOf:
        - $ref: '#/components/schemas/TransactionOperationDTO'
        - $ref: '#/components/schemas/InstrumentOperationDTO'
        - $ref: '#/components/schemas/RejectedInstrumentOperationDTO'
        - $ref: '#/components/schemas/IbanOperationDTO'
        - $ref: '#/components/schemas/OnboardingOperationDTO'
        - $ref: '#/components/schemas/RefundOperationDTO'
        - $ref: '#/components/schemas/SuspendOperationDTO'
        - $ref: '#/components/schemas/ReadmittedOperationDTO'
        - $ref: '#/components/schemas/UnsubscribeOperationDTO'
    RejectedInstrumentOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - channel
      properties:
        operationId:
          type: string
          description: 'ENG: Id of operation - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - REJECTED_ADD_INSTRUMENT
            - REJECTED_DELETE_INSTRUMENT
          description: 'ENG: Operation type [REJECTED_ADD_INSTRUMENT: Rejected add instrument,
                      REJECTED_DELETE_INSTRUMENT: Rejected delete instrument] - IT: Tipologia di operazione [REJECTED_ADD_INSTRUMENT: Respinto l''inserimento dello strumento,
                      REJECTED_DELETE_INSTRUMENT: Respinta la cancellazione dello strumento]'
          example: 'REJECTED_ADD_INSTRUMENT'
          type: string
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
        brandLogo:
          type: string
          format: uri
          description: 'ENG: Card''s brand logo URL - IT: URL del logo del marchio della carta'
        brand:
          type: string
          description: 'ENG: Card''s brand as mastercard, visa, ecc. - IT: Marchio della carta come mastercard, visa, ecc...'
        instrumentId:
          type: string
          description: 'ENG: Id instrument - IT: Identificativo dello strumento'
        maskedPan:
          type: string
          example: '1234-****-****-5678'
          description: 'ENG: masked PAN - IT: masked PAN'
        channel:
          type: string
          enum:
            - RTD
            - QRCODE
            - IDPAYCODE
            - BARCODE
          example: 'BARCODE'
          description: 'ENG: Channel from which the operation takes place - IT: Canale da cui avviene l''operazione'
        instrumentType:
          type: string
          enum:
            - CARD
            - IDPAYCODE
          example: 'CARD'
          description: 'ENG: Instrument type - IT: Tipologia di strumento'
    TransactionDetailDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - accruedCents
        - status
      properties:
        operationId:
          type: string
          description: 'ENG: Id of the operation - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          example: 'REVERSAL'
          type: string
          description: 'ENG: Operation type - IT: Tipologia di operazione'
        eventId:
          type: string
        brandLogo:
          type: string
          format: uri
          description: 'ENG: Card''s brand logo URL - IT: URL del logo del marchio della carta'
        brand:
          type: string
          description: 'ENG: Card''s brand as mastercard, visa, ecc. - IT: Marchio della carta come mastercard, visa, ecc...'
        maskedPan:
          type: string
          example: '1234-****-****-5678'
          description: 'ENG: Masked Pan - IT: Masked Pan'
        amountCents:
          type: integer
          format: int64
          description: 'ENG: Transaction amount - IT: Importo della transazione'
        accruedCents:
          type: integer
          format: int64
          description: 'ENG: Transaction accrued - IT: Importo accumulato'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
        circuitType:
          type: string
          example: '00'
          description: >-
              ENG: Circuit type - IT: Tipologia del circuito
              00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB,
              05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay,
              09->Satispay, 10->PrivateCircuit
        idTrxIssuer:
          type: string
          description: 'ENG: Transaction issuer ID - IT: Identificativo della transazione rispetto all''issuer'
        idTrxAcquirer:
          type: string
          description: 'ENG: Transaction acquirer ID- IT: Identificativo della transazione rispetto all''acquirer'
        status:
          type: string
          enum:
            - AUTHORIZED
            - REWARDED
            - CANCELLED
          example: 'CANCELLED'
          description: 'ENG: Transaction status [AUTHORIZED: Transaction authorize, REWARDED: Transaction rewarded, CANCELLED: Transaction cancelled]  - IT: Stato della transazione [AUTHORIZED: Transazione autorizzata, REWARDED: Transazione premiata, CANCELLED: transazione cancellata]'
        channel:
          type: string
          enum:
            - RTD
            - QRCODE
            - IDPAYCODE
            - BARCODE
          example: 'BARCODE'
          description: 'ENG: Channel from which the transaction takes place - IT: Canale da cui avviene la transazione'
        businessName:
          type: string
    InstrumentOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - instrumentType
        - channel
      properties:
        operationId:
          type: string
          description: 'ENG: Operation ID - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - ADD_INSTRUMENT
            - DELETE_INSTRUMENT
          type: string
          description: 'ENG: Operation type - IT: Tipologia di operazione'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
        brandLogo:
          type: string
          format: uri
          description: 'ENG: Card''s brand logo URL - IT: URL del logo del marchio della carta'
        brand:
          type: string
          description: 'ENG: Card''s brand as mastercard, visa, ecc. - IT: Marchio della carta come mastercard, visa, ecc...'
        maskedPan:
          type: string
          example: '1234-****-****-5678'
          description: 'ENG: Masked Pan - IT: Masked Pan'
        channel:
          type: string
          enum:
            - RTD
            - QRCODE
            - IDPAYCODE
            - BARCODE
          example: 'BARCODE'
          description: 'ENG: Channel from which the operation takes place - IT: Canale da cui avviene l''operazione'
        instrumentType:
          type: string
          enum:
            - CARD
            - IDPAYCODE
    IbanOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - iban
        - channel
      properties:
        operationId:
          type: string
          description: 'ENG: Operation ID - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - ADD_IBAN
          type: string
          description: 'ENG: Operation type - IT: Tipologia dell''operazione'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
        iban:
          type: string
          description: 'ENG: IBAN of the citizen - IT: IBAN del cittadino'
        channel:
          type: string
          enum:
            - RTD
            - QRCODE
            - IDPAYCODE
            - BARCODE
          example: 'BARCODE'
          description: 'ENG: Channel from which the operation takes place - IT: Canale da cui avviene l''operazione'
    OnboardingOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
          description: 'ENG: Operation ID - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - ONBOARDING
          type: string
          description: 'ENG: Operaztion type - IT: Tipologia dell''operazione'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
    RefundOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - eventId
        - operationDate
        - amountCents
      properties:
        operationId:
          type: string
          description: 'ENG: Operation ID - IT: Identificativo dell''operazione'
        eventId:
          type: string
          description: 'ENG: Event ID - IT: Identificativo dell''evento'
        operationType:
          enum:
            - PAID_REFUND
            - REJECTED_REFUND
          type: string
          description: 'ENG: Operation type [PAID_REFUND: Paid refund, REJECTED_REFUND: Rejected refund] - IT: Tipologia dell''operazione [PAID_REFUND: Rimborso pagato, REJECTED_REFUND: Rimborso rifiutato]'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
        amountCents:
          type: integer
          format: int64
          description: 'ENG: Refund amount - IT: Importo da rimborsare'
    TransactionOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
        - accruedCents
        - status
      properties:
        operationId:
          type: string
          description: 'ENG: Id of the operation - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - TRANSACTION
            - REVERSAL
          type: string
          description: 'ENG: Operation type - IT: Tipologia dell''operazione'
        eventId:
          type: string
          description: 'ENG: Event ID - IT: Identificativo dell''evento'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
        brandLogo:
          type: string
          format: uri
          description: 'ENG: Card''s brand logo URL - IT: URL del logo del marchio della carta'
        brand:
          type: string
          description: 'ENG: Card''s brand as mastercard, visa, ecc. - IT: Marchio della carta come mastercard, visa, ecc...'
        maskedPan:
          type: string
          example: '1234-****-****-5678'
          description: 'ENG: Masked PAN - IT: Masked PAN'
        amountCents:
          type: integer
          format: int64
          description: 'ENG: Transaction amount - IT: Importo della transazione'
        accruedCents:
          type: integer
          format: int64
          description: 'ENG: Accrued amount - IT: Importo accumulato'
        circuitType:
          type: string
          example: '00'
          description: >-
             ENG: Circuit type - IT: Tipologia di circuito
             00-> Bancomat, 01->Visa, 02->Mastercard, 03->Amex, 04->JCB,
             05->UnionPay, 06->Diners, 07->PostePay, 08->BancomatPay,
             09->Satispay, 10->PrivateCircuit
        status:
          type: string
          enum:
            - AUTHORIZED
            - REWARDED
            - CANCELLED
          example: 'CANCELLED'
          description: 'ENG: Transaction status  - IT: Stato della transazione'
        channel:
          type: string
          enum:
            - RTD
            - QRCODE
            - IDPAYCODE
            - BARCODE
          example: 'BARCODE'
          description: 'ENG: Channel from which the transaction takes place - IT: Canale da cui avviene la transazione'
        businessName:
          type: string
    SuspendOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
          description: 'ENG: Operation ID - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - SUSPENDED
          example: 'SUSPENDED'
          type: string
          description: 'ENG: Operation type [SUSPENDED: Suspended] - IT: Tipologia dell''operazione [SUSPENDED: sospeso]'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
    RefundDetailDTO:
      type: object
      required:
        - operationId
        - operationType
        - eventId
        - operationDate
        - amountCents
      properties:
        operationId:
          type: string
          description: 'ENG: Operation ID - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - PAID_REFUND
            - REJECTED_REFUND
          type: string
          example: 'REJECTED_REFUND'
          description: 'ENG: Operation type [PAID_REFUND: Paid refund, REJECTED_REFUND: Rejected refund] - IT: Tipologia dell''operazione [PAID_REFUND: Rimborso pagato, REJECTED_REFUND: Rimborso rifiutato]'
        eventId:
          type: string
          description: 'ENG: Event ID - IT: Identificativo dell''evento'
        iban:
          type: string
          description: 'ENG: IBAN - IT: IBAN'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
        amountCents:
          type: integer
          format: int64
          description: 'ENG: Refund amount - IT: Importo da rimborsare'
        status:
          type: string
          description: 'ENG: Refund status - IT: Stato del rimborso'
        refundType:
          type: string
          description: 'ENG: Refund type - IT: Tipologia di rimborso'
        startDate:
          type: string
          format: date
          description: 'ENG: Start date - IT: Data di inizio'
        endDate:
          type: string
          format: date
          description: 'ENG: End date - IT Data di fine'
        transferDate:
          type: string
          format: date

          description: 'ENG: Transfer date - IT: Data della trasferenza'
        userNotificationDate:
          type: string
          format: date
          description: 'ENG: User notification date - IT: Data di notificazione all''utente'
        cro:
          type: string
          description: 'ENG: Code that identifies a bank transaction/credit transfer - IT: Codice che identifica una transazione bancaria/bonifico'
    ReadmittedOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
          description: 'ENG: Id of the operation - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - READMITTED
          example: 'READMITTED'
          type: string
          description: 'ENG: Operation type - IT: Tipologia dell''operazione'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
    TimelineErrorDTO:
      type: object
      required:
        - code
        - message
      properties:
        code:
          type: string
          enum:
            - TIMELINE_DETAIL_NOT_FOUND
            - TIMELINE_USER_NOT_FOUND
            - TIMELINE_REFUNDS_NOT_FOUND
            - TIMELINE_INVALID_REQUEST
            - TIMELINE_TOO_MANY_REQUESTS
            - TIMELINE_GENERIC_ERROR
          description: >-
           'ENG: Error code: TIMELINE_DETAIL_NOT_FOUND: Detail of Timeline not found,
            TIMELINE_USER_NOT_FOUND: Timeline for the current user not found,
            TIMELINE_REFUNDS_NOT_FOUND: Refund for current initiative not found,
            TIMELINE_INVALID_REQUEST: Something went wrong handling request,
            TIMELINE_TOO_MANY_REQUESTS: Too many requests,
            TIMELINE_GENERIC_ERROR: Application Error - IT: Codice di errore:
            TIMELINE_DETAIL_NOT_FOUND: Dettaglio della Timeline non trovato,
            TIMELINE_USER_NOT_FOUND: Timeline per utente corrente non trovata,
            TIMELINE_REFUNDS_NOT_FOUND:  Rimborso per la corrente iniziativa non trovato,
            TIMELINE_INVALID_REQUEST: Qualcosa è andato storto durante l'invio della richiesta,
            TIMELINE_TOO_MANY_REQUESTS: Troppe richieste,
            TIMELINE_GENERIC_ERROR: Errore generico'
          example: 'TIMELINE_DETAIL_NOT_FOUND'
        message:
          type: string
          description: 'ENG: Error message - IT: Messaggio di errore'
    UnsubscribeOperationDTO:
      type: object
      required:
        - operationId
        - operationType
        - operationDate
      properties:
        operationId:
          type: string
          description: 'ENG: Id of the operation - IT: Identificativo dell''operazione'
        operationType:
          enum:
            - UNSUBSCRIBED
          example: 'UNSUBSCRIBED'
          type: string
          description: 'ENG: Operation type - IT: Tipologia dell''operazione'
        operationDate:
          type: string
          format: date-time
          description: 'ENG: Operation date - IT: Data dell''operazione'
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
security:
  - bearerAuth: []
tags:
  - name: timeline
    description: ''
