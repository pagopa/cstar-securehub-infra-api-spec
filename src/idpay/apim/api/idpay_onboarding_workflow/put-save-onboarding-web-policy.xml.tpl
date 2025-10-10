<!--
    IMPORTANT:
    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.
    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.
    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.
    - To add a policy, place the cursor at the desired insertion point and select a policy from the sidebar.
    - To remove a policy, delete the corresponding policy statement from the policy document.
    - Position the <base> element within a section element to inherit all policies from the corresponding section element in the enclosing scope.
    - Remove the <base> element to prevent inheriting policies from the corresponding section element in the enclosing scope.
    - Policies are applied in the order of their appearance, from the top down.
    - Comments within policy elements are not supported and may disappear. Place your comments between policy elements or at a higher level scope.
-->
<policies>
    <inbound>
        <base />
        <set-variable name="jwt_decoded" value="@((Jwt)context.Variables["jwt"])" />
        <!-- Estrai given_name / family_name con fallback su 'name' (split) -->
        <set-variable name="givenName" value="@{
        var j = (Jwt)context.Variables["jwt_decoded"];
        string given = j.Claims.ContainsKey("given_name") ? j.Claims["given_name"].FirstOrDefault() : null;
        if (string.IsNullOrEmpty(given) && j.Claims.ContainsKey("name")) {
            var parts = (j.Claims["name"].FirstOrDefault() ?? "").Split(' ');
            if (parts.Length > 0) { given = parts[0]; }
        }
        return given;
        }" />
        <set-variable name="familyName" value="@{
        var j = (Jwt)context.Variables["jwt_decoded"];
        string family = j.Claims.ContainsKey("family_name") ? j.Claims["family_name"].FirstOrDefault() : null;
        if (string.IsNullOrEmpty(family) && j.Claims.ContainsKey("name")) {
            var parts = (j.Claims["name"].FirstOrDefault() ?? "").Split(' ');
            if (parts.Length > 1) { family = parts[parts.Length-1]; }
        }
        return family;
        }" />
        <choose>
            <when condition="@(
            string.Equals(context.Request.Method, "POST", StringComparison.OrdinalIgnoreCase) ||
            string.Equals(context.Request.Method, "PUT",  StringComparison.OrdinalIgnoreCase) ||
            string.Equals(context.Request.Method, "PATCH",StringComparison.OrdinalIgnoreCase)
            )">
                <set-variable name="bodyWithNames" value="@{
            var body = context.Request.Body?.As<JObject>(preserveContent: true) ?? new JObject();

            var given  = (string)context.Variables["givenName"];
            var family = (string)context.Variables["familyName"];

            body["name"] = given  ?? string.Empty;
            body["surname"] = family ?? string.Empty;

            return body.ToString();
            }" />
        <set-body>@((string)context.Variables["bodyWithNames"])</set-body>
        <set-header name="Content-Type" exists-action="override">
            <value>application/json</value>
        </set-header>
        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpayonboardingworkflow" />
        <rewrite-uri template="@("idpay/onboarding/"+ (string)context.Variables["userId"])" />
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
