<policies>
    <inbound>
        <base />
        <!-- Require a validated internal token and an authorized operator role. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-any" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- Keep the BFF route and forward query parameters unchanged. -->
        <rewrite-uri template="/emd/backoffice/api/v1/citizen/search" copy-unmatched-params="true" />
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
