<policies>
    <inbound>
        <base />
        <!-- Toggle is write-only: allow operator-write and operator-admin roles. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-write" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- The toggle endpoint is bodyless; discard any inbound payload before forwarding. -->
        <set-body>@(string.Empty)</set-body>
        <!-- Escape each path segment while preserving the BFF route. -->
        <rewrite-uri template='@("/emd/backoffice/api/v1/citizen/" + Uri.EscapeDataString((string)context.Request.MatchedParameters["fiscalCode"]) + "/consents/" + Uri.EscapeDataString((string)context.Request.MatchedParameters["tppId"]))' />
    </inbound>
    <backend>
        <!-- Do not inherit the product retry: replaying a toggle could invert the consent twice. -->
        <forward-request />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
