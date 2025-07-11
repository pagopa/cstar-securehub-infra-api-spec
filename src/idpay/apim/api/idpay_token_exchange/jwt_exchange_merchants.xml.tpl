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
                <audience>idpay.merchant.welfare.pagopa.it</audience>
            </audiences>
            <issuers>
                <issuer>${selfcare-issuer}</issuer>
            </issuers>
        </validate-jwt>

        <set-variable name="acquirerId" value="PAGOPA" />
        <set-variable name="merchantFiscalCode" value="@{
            Jwt selcToken = (Jwt)context.Variables["outputToken"];

            JObject organization = JObject.Parse(selcToken.Claims.GetValueOrDefault("organization", "{}"));
            return organization["fiscal_code"].ToString();
        }" />

        <include-fragment fragment-id="idpay-itn-merchant-id-retriever" />

        <set-variable name="idpayPortalToken" value="@{
                    Jwt selcToken = (Jwt)context.Variables["outputToken"];
                    var JOSEProtectedHeader = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
                        new {
                            typ = "JWT",
                            alg = "RS256"
                        }))).Split('=')[0].Replace('+', '-').Replace('/', '_');

                    var iat = DateTimeOffset.Now.ToUnixTimeSeconds();
                    var exp = new DateTimeOffset(DateTime.Now.AddHours(8)).ToUnixTimeSeconds();  // sets the expiration of the token to be 8 hours from now
                    var aud = "idpay.merchant.welfare.pagopa.it";
                    var iss = "https://api-io.dev.cstar.pagopa.it";
                    var uid = selcToken.Claims.GetValueOrDefault("uid", "");
                    var acquirer_id = (String)context.Variables["acquirerId"];
                    var merchant_id = (String)context.Variables["merchantId"];
                    var name = selcToken.Claims.GetValueOrDefault("name", "");
                    var family_name = selcToken.Claims.GetValueOrDefault("family_name", "");
                    var email = selcToken.Claims.GetValueOrDefault("email", "");
                    JObject organization = JObject.Parse(selcToken.Claims.GetValueOrDefault("organization", "{}"));
                    var org_id = organization["id"];
                    var org_vat = organization["fiscal_code"];
                    var org_name = organization["name"];
                    var org_party_role = organization.Value<JArray>("roles").First().Value<string>("partyRole");
                    var org_role = organization.Value<JArray>("roles").First().Value<string>("role");
                    var payload = Convert.ToBase64String(Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(
                    new {
                    iat,
                    exp,
                    aud,
                    iss,
                    uid,
                    name,
                    family_name,
                    email,
                    acquirer_id,
                    merchant_id,
                    org_id,
                    org_vat,
                    org_name,
                    org_party_role,
                    org_role
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
