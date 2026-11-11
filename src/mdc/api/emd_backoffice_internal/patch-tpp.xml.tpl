<policies>
    <inbound>
        <base />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <rewrite-uri template="/emd/backoffice/api/v1/tpp/{entityId}" />    </inbound>
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
