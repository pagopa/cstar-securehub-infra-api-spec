<policies>
    <inbound>
        <base />
        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/zendesk-connector" />
        <rewrite-uri template="support" />
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
