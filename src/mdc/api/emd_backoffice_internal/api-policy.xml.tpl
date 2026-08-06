<policies>
    <inbound>
        <base />
        <cors allow-credentials="true">
            <allowed-origins>
                <origin>${mdcBackofficeInternalUrl}</origin>
            </allowed-origins>
            <allowed-methods>
                <method>GET</method>
                <method>POST</method>
                <method>PUT</method>
                <method>DELETE</method>
                <method>PATCH</method>
                <method>OPTIONS</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
        </cors>
        <!-- Extract operator roles from the validated internal Keycloak token once at API level.
             Roles are stored as a comma-separated string so operation fragments can call .Split(',').Contains(...).
             NOTE: Keycloak emits this claim as "role" (singular), not "roles".
             Expected values: operator-read, operator-write, operator-admin. -->
        <set-variable name="roles"
            value="@(string.Join(",", ((Jwt)context.Variables["mdcToken"]).Claims.GetValueOrDefault("role", new string[0])))" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
        <set-header name="Access-Control-Allow-Origin" exists-action="override">
            <value>${mdcBackofficeInternalUrl}</value>
        </set-header>
        <set-header name="Access-Control-Allow-Credentials" exists-action="override">
            <value>true</value>
        </set-header>
    </on-error>
</policies>

