<policies>
    <inbound>
        <base />
        <!-- Retry requests are restricted to operator-write and operator-admin roles. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-write" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emdnotifiersender" />
        <rewrite-uri template="/emd/notifier-sender/messages/retry" />
    </inbound>
    <backend>
        <!-- Do not inherit retry behavior for this non-idempotent POST operation. -->
        <forward-request />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
