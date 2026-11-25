<policies>
    <inbound>
        <base />
%{ if enabled ~}
        <!-- Operation enabled only on the environments. -->
        <choose>
            <when condition="@(!System.Text.RegularExpressions.Regex.IsMatch((string)context.Request.MatchedParameters["fiscalCode"], "^[A-Za-z0-9]{11,16}$") || !System.Text.RegularExpressions.Regex.IsMatch((string)context.Request.MatchedParameters["tppId"], "^[ -~]{1,50}$"))">
                <return-response>
                    <set-status code="400" reason="Bad Request" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>{"code":"BAD_REQUEST","message":"Invalid fiscalCode format"}</set-body>
                </return-response>
            </when>
        </choose>
        <!-- Consent creation is a write operation: allow operator-write and operator-admin roles. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-write" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- Escape each path segment while preserving the BFF route. -->
        <rewrite-uri template="@("/emd/backoffice/api/v1/citizen/{fiscalCode}/consents/{tppId}")" />
%{ else ~}
        <!-- Operation not enabled on this environment: always answer 404 without reaching the backend. -->
        <return-response>
            <set-status code="404" reason="Not Found" />
        </return-response>
%{ endif ~}
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
