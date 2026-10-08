<policies>
    <inbound>
        <base />
        <!-- Aggregate deletion is write-only: allow operator-write and operator-admin roles. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-write" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- This operation accepts no body or query parameters. -->
        <set-body>@(string.Empty)</set-body>
        <!-- Escape fiscalCode as one path segment before routing to the BFF. -->
        <rewrite-uri template='@("/emd/backoffice/api/v1/citizen/" + Uri.EscapeDataString((string)context.Request.MatchedParameters["fiscalCode"]))' copy-unmatched-params="false" />
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
