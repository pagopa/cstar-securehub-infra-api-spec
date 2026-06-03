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
        <cors allow-credentials="true">
            <allowed-origins>
              %{ for origin in origins ~}
              <origin>${origin}</origin>
              %{ endfor ~}
            </allowed-origins>
            <allowed-methods preflight-result-max-age="300">
                <method>*</method>
            </allowed-methods>
            <allowed-headers>
                <header>*</header>
            </allowed-headers>
            <expose-headers>
                <header>*</header>
            </expose-headers>
        </cors>
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" require-expiration-time="true" require-scheme="Bearer" require-signed-tokens="true" output-token-variable-name="outputToken">
            <openid-config url="${openid-config-url}" />
            <audiences>
                <audience>idpay.register.welfare.pagopa.it</audience>
            </audiences>
            <issuers>
                <issuer>${selfcare-issuer}</issuer>
                <issuer>PAGOPA</issuer>
            </issuers>
        </validate-jwt>
        <set-variable name="institutionId" value="@{
            Jwt selcToken = (Jwt)context.Variables["outputToken"];
            JObject organization = JObject.Parse(selcToken.Claims.GetValueOrDefault("organization", "{}"));
            return organization["id"].ToString();
        }" />
        <set-variable name="userId" value="@{
            Jwt selcToken = (Jwt)context.Variables["outputToken"];
            return selcToken.Claims.GetValueOrDefault("uid", "{}");
        }" />

        <set-variable name="isSupport" value="@{
            Jwt selcToken = (Jwt)context.Variables["outputToken"];
            JObject organization = JObject.Parse(selcToken.Claims.GetValueOrDefault("organization", "{}"));
            var roles = organization["roles"] as JArray;
            return roles != null && roles.Any(r => r["role"]?.ToString() == "support");
        }" />

        <choose>
            <when condition="@(!(bool)context.Variables["isSupport"])">
                <send-request mode="new" response-variable-name="institutionResponse" timeout="10" ignore-error="false">
                    <set-url>@("${selfcare_base_url}"+"/institutions/"+context.Variables["institutionId"])</set-url>
                    <set-method>GET</set-method>
                    <set-header name="Ocp-Apim-Subscription-Key" exists-action="override">
                        <value>{{${selfcare_api_key_reference}}}</value>
                    </set-header>
                </send-request>

                <send-request mode="new" response-variable-name="userResponse" timeout="10" ignore-error="false">
                    <set-url>@("${selfcare_base_url}/users/"+context.Variables["userId"]+"?institutionId="+context.Variables["institutionId"])</set-url>
                    <set-method>GET</set-method>
                    <set-header name="Ocp-Apim-Subscription-Key" exists-action="override">
                        <value>{{${selfcare_api_key_reference}}}</value>
                    </set-header>
                </send-request>
            </when>
        </choose>

        <choose>
            <when condition="@((bool)context.Variables["isSupport"] || (((IResponse)context.Variables["institutionResponse"]).StatusCode == 200 && ((IResponse)context.Variables["userResponse"]).StatusCode == 200))">
                <set-variable name="idpayPortalToken" value="@{
                    Jwt selcToken = (Jwt)context.Variables["outputToken"];

                    var JOSEProtectedHeader = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
                        new {
                            typ = "JWT",
                            alg = "RS256"
                        }))).Split('=')[0].Replace('+', '-').Replace('/', '_');

                    var iat = DateTimeOffset.Now.ToUnixTimeSeconds();
                    var exp = new DateTimeOffset(DateTime.Now.AddHours(8)).ToUnixTimeSeconds();
                    var aud = "idpay.register.welfare.pagopa.it";
                    var iss = "https://api-io.dev.cstar.pagopa.it";

                    var uid = selcToken.Claims.GetValueOrDefault("uid", "");
                    var name = selcToken.Claims.GetValueOrDefault("name", "");
                    var family_name = selcToken.Claims.GetValueOrDefault("family_name", "");
                    var email = selcToken.Claims.GetValueOrDefault("email", "");

                    JObject organization = JObject.Parse(selcToken.Claims.GetValueOrDefault("organization", "{}"));
                    var org_id = organization["id"];
                    var org_name = organization["name"];

                    var roles = organization["roles"] as JArray;
                    var inputRole = roles?.FirstOrDefault()?["role"]?.ToString();
                    var inputPartyRole = roles?.FirstOrDefault()?["partyRole"]?.ToString();

                    string org_role;
                    string org_party_role = inputPartyRole;
                    var fiscalCode = organization["fiscal_code"]?.ToString();

                    if (inputRole == "support")
                    {
                        org_role = "support";
                        org_party_role = inputPartyRole ?? "PRODUCT"; 
                    }
                    else if (fiscalCode == "${invitalia_fc}")
                    {
                        if (roles != null && roles.Any(r => r["role"]?.ToString() == "operator2"))
                        {
                            org_role = "invitalia_admin";
                            org_party_role = "Admin Invitalia";
                        }
                        else
                        {
                            org_role = "invitalia";
                            org_party_role = "Operatore Invitalia";
                        }
                    }
                    else
                    {
                        org_role = "operatore";
                    }

                    string org_email = email;
                    string org_address = "";
                    string org_pec = "";
                    string org_fc = fiscalCode;
                    string org_vat = "-";

                    if (inputRole != "support")
                    {
                        var response = (IResponse)context.Variables["institutionResponse"];
                        var body = response.Body.As<JObject>();

                        org_address = (string)body["address"] + ", " + (string)body["zipCode"] + " " + (string)body["city"] + " (" + (string)body["county"] + ")";
                        org_pec = (string)body["digitalAddress"];
                        org_fc = (string)body["taxCode"];

                        var onboardingArray = body["onboarding"] as JArray;
                        org_vat = onboardingArray?
                            .Children<JObject>()
                            .FirstOrDefault(o => o["billing"] != null)?["billing"]?["vatNumber"]?.ToString() ?? "-";

                        response = (IResponse)context.Variables["userResponse"];
                        body = response.Body.As<JObject>();
                        org_email = (string)body["email"];
                    }

                    var payload = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
                        new {
                            iat,
                            exp,
                            aud,
                            iss,
                            uid,
                            name,
                            family_name,
                            org_email,
                            org_id,
                            org_vat,
                            org_fc,
                            org_name,
                            org_party_role,
                            org_role,
                            org_address,
                            org_pec
                        }
                    ))).Split('=')[0].Replace('+', '-').Replace('/', '_');

                    var message = ($"{JOSEProtectedHeader}.{payload}");

                     using (RSA rsa = context.Deployment.Certificates["${jwt_cert_signing_thumbprint}"].GetRSAPrivateKey())
                    {
                        var signature = rsa.SignData(Encoding.UTF8.GetBytes(message), HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
                        return message + "." + Convert.ToBase64String(signature).Split('=')[0].Replace('+', '-').Replace('/', '_');
                    }
                    return message;
                }" />
                <return-response>
                    <set-body>@((string)context.Variables["idpayPortalToken"])</set-body>
                </return-response>
            </when>
            <otherwise>
                <return-response>
                    <set-status code="500" />
                </return-response>
            </otherwise>
        </choose>
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
