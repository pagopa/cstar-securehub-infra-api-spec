<policies>
    <inbound>
        <base />
        <!-- Authorization delegated to fragment: operator-admin roles only. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-admin" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <rewrite-uri template="/emd/backoffice/api/v1/users" />
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
