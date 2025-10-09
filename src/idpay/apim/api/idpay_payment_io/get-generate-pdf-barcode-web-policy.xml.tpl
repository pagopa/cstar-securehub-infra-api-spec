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
        <!-- Fiscal code: prima da 'pii' (ereditato dal prodotto), poi dal claim 'fiscalNumber' del JWT -->
        <set-variable name="fiscalCode" value="@{
            string fc = context.Variables.ContainsKey("pii") ? (string)context.Variables["pii"] : null;
            if (string.IsNullOrEmpty(fc) && context.Variables.ContainsKey("jwt")) {
                var j = (Jwt)context.Variables["jwt"];
                if (j.Claims.ContainsKey("fiscalNumber")) {
                    fc = j.Claims["fiscalNumber"].FirstOrDefault();
                }
            }
            return fc ?? "";
        }" />

        <!-- Username dal JWT validato a livello prodotto (name -> given_name+family_name -> preferred_username) -->
        <set-variable name="username" value="@{
            string name = "";
            if (context.Variables.ContainsKey("jwt")) {
                var jwt = (Jwt)context.Variables["jwt"];

                if (jwt.Claims.ContainsKey("name")) {
                    name = jwt.Claims["name"].FirstOrDefault();
                }

                if (string.IsNullOrEmpty(name)) {
                    string gn = jwt.Claims.ContainsKey("given_name") ? jwt.Claims["given_name"].FirstOrDefault() : null;
                    string fn = jwt.Claims.ContainsKey("family_name") ? jwt.Claims["family_name"].FirstOrDefault() : null;
                    if (!string.IsNullOrEmpty(gn) && !string.IsNullOrEmpty(fn)) {
                        name = gn + " " + fn;
                    } else if (!string.IsNullOrEmpty(gn)) {
                        name = gn;
                    } else if (!string.IsNullOrEmpty(fn)) {
                        name = fn;
                    }
                }

            }
            return name ?? "";
        }" />

        <!-- Propaga gli header verso il backend -->
        <set-header name="X-Username" exists-action="override">
            <value>@((string)context.Variables["username"] ?? "")</value>
        </set-header>
        <set-header name="X-Fiscal-Code" exists-action="override">
            <value>@((string)context.Variables["fiscalCode"] ?? "")</value>
        </set-header>
        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpaypayment" />
        <rewrite-uri template="@("idpay/payment/initiatives/{initiativeId}/bar-code/{trxCode}/pdf")" />
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
