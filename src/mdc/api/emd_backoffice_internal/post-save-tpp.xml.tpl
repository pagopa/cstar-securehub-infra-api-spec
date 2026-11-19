<policies>
    <inbound>
        <base />
%{ if enabled ~}
        <!-- Authorization delegated to fragment: operator-write or operator-admin roles only.
             Operation enabled only on the environments. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-write" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <rewrite-uri template="/emd/backoffice/api/v1/tpp/{entityId}" />
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
