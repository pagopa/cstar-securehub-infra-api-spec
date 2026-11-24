<policies>
    <inbound>
        <base />
        <!-- Authorization delegated to fragment: any operator role (read, write, or admin) is accepted. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-any" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- Preserve the optional query parameters unchanged for the BFF. -->
        <rewrite-uri template="/emd/backoffice/api/v1/payment-core/attempts/search" copy-unmatched-params="true" />
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
