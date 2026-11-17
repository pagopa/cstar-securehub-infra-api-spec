<policies>
    <inbound>
        <base />
        <!-- Authorization delegated to fragment: any operator role (read, write, or admin) is accepted. -->
        <include-fragment fragment-id="emd-backoffice-internal-authorize-operator-any" />
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emd-ar-backoffice-bff" />
        <!-- Effettua il rewrite per far matchare il path del backend Spring Boot -->
        <rewrite-uri template="/emd/backoffice/api/v1/tpp/template/validate" />
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
