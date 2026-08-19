<policies>
    <inbound>
        <base />
        <!-- Authorization delegated to fragment: operator-write or operator-admin roles only.
             Administrative operation to enable/disable payment capabilities. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-write" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- Rewriting to the internal BFF endpoint using tppId from path -->
        <rewrite-uri template="/emd/backoffice/api/v1/tpp/{tppId}/payment-enabled" />
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