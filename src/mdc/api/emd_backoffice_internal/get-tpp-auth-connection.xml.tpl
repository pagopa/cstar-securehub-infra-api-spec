<policies>
    <inbound>
        <base />
        <!-- Authorization delegated to fragment: any operator role (read, write, or admin) is accepted.
             Swap fragment id to restrict access to specific roles on future endpoints:
               emd-authorize-operator-write  → write or admin only
               emd-authorize-operator-admin  → admin only -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-any" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <rewrite-uri template="/emd/backoffice/api/v1/tpp/{tppId}/network/connection/test" />
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
