<policies>
    <inbound>
        <base />
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-any" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- Use APIM's operation-template parameter binding, not string concatenation, to retain and encode each path segment. -->
        <rewrite-uri template="/emd/backoffice/api/v1/payment-core/attempts/{tppId}/{iun}" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>

