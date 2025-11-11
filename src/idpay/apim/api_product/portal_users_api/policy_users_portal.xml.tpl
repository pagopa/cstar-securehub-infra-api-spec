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
        <rate-limit calls="${rate_limit_users_portal}" renewal-period="60" />
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
        <!-- Extract Token from Authorization header parameter -->
        <set-variable name="token" value="@(context.Request.Headers.GetValueOrDefault("Authorization","scheme param").Split(' ').Last())" />
        <!-- The variable present in cache is the pii of the user obtaind with PDV  /-->
        <cache-lookup-value key="@((string)context.Variables["token"]+"-kc-idpay")" variable-name="tokenPDV" />
        <set-variable name="bypassCacheStorage" value="false" />

        <!-- JWT validation with OpenID Connect -->
        <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid." output-token-variable-name="jwt">
            <openid-config url="${openid_config_url_user}" />
            <required-claims>
                <claim name="iss">
                    <value>${keycloak_url_user}</value>
                </claim>
            </required-claims>
        </validate-jwt>
        <set-variable name="azp" value="@(((Jwt)context.Variables["jwt"]).Claims.GetValueOrDefault("azp", ""))" />
        <choose>
            <when condition="@((string)context.Variables["azp"] != "${user_client_id}" && (string)context.Variables["azp"] != "${users_op_client_id_test}")">
                <return-response>
                    <set-status code="401" reason="Unauthorized" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>{"statusCode":401,"message":"Unauthorized. Invalid azp claim."}</set-body>
                </return-response>
            </when>
        </choose>
                <!-- Extract fiscalNumber of token -->
                <set-variable name="pii" value="@(((Jwt)context.Variables["jwt"]).Claims.ContainsKey("fiscalNumber")
    ? ((Jwt)context.Variables["jwt"]).Claims["fiscalNumber"].FirstOrDefault()
    : null)" />
        <choose>
            <!-- If API Management doesn’t find it in the cache, validate and make a request for it and store it -->
            <when condition="@(!context.Variables.ContainsKey("tokenPDV"))">

                <choose>
                    <!-- Retrieve fiscalCode from keycloak userInfo/account -->
                    <when condition="@(string.IsNullOrEmpty((string)context.Variables["pii"]))">
                        <send-request mode="new" response-variable-name="userinfo_resp" timeout="${keycloak_timeout_sec}" ignore-error="true">
                            <set-url>${keycloak_url_user_account}</set-url>
                            <set-method>GET</set-method>
                            <set-header name="Authorization" exists-action="override">
                                <value>@("Bearer " + (string)context.Variables["token"])</value>
                            </set-header>
                            <set-header name="Accept" exists-action="override">
                                <value>application/json</value>
                            </set-header>
                        </send-request>
                        <!-- Extract fiscalNumber -->
                        <set-variable name="pii" value="@(((Jwt)context.Variables["jwt"]).Claims.ContainsKey("fiscalNumber") ? ((Jwt)context.Variables["jwt"]).Claims["fiscalNumber"].FirstOrDefault() : null)" />
                        <choose>
                            <when condition="@((object)context.Variables["userinfo_resp"] == null)">
                                <return-response>
                                    <set-status code="504" reason="Keycloak UserInfo Timeout" />
                                </return-response>
                            </when>
                            <when condition="@(((IResponse)context.Variables["userinfo_resp"]).StatusCode == 200)">
                                <set-variable name="bypassCacheStorage" value="true" />
                                <choose>
                                    <when condition="@(((JObject)((IResponse)context.Variables["userinfo_resp"]).Body.As<JObject>(preserveContent: true))["attributes"]?["fiscalNumber"]?[0] == null)">
                                        <!-- Return 401 Unauthorized with http-problem payload -->
                                        <return-response>
                                            <set-status code="401" reason="Unauthorized" />
                                            <set-header name="WWW-Authenticate" exists-action="override">
                                                <value>Bearer error="invalid_token"</value>
                                            </set-header>
                                        </return-response>
                                    </when>
                                    <otherwise>
                                        <set-variable name="pii" value="@(((JObject)((IResponse)context.Variables["userinfo_resp"]).Body.As<JObject>(preserveContent: true))["attributes"]?["fiscalNumber"]?[0]?.ToString() ?? "")" />
                                    </otherwise>
                                </choose>
                            </when>
                            <otherwise>
                                <return-response>
                                    <set-status code="401" reason="Unauthorized" />
                                </return-response>
                            </otherwise>
                        </choose>
                    </when>
                </choose>
                <!-- Validate Fiscal Number -->
                %{ if env_short == "p" ~}
                <choose>
                    <when condition="@(!Regex.IsMatch((string)context.Variables["pii"], "^([A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1})$"))">
                        <return-response>
                            <set-status code="400" reason="Bad Request" />
                            <set-header name="Content-Type" exists-action="override">
                                <value>application/json</value>
                            </set-header>
                            <set-body>{
                                                "code": "FISCAL_CODE_NOT_VALID",
                                                "message": "Fiscal code not valid!"
                                            }</set-body>
                        </return-response>
                    </when>
                </choose>
                %{ endif ~}
                <!-- Retrieve tokenizer user -->
                <include-fragment fragment-id="idpay-datavault-tokenizer" />
                <choose>
                    <when condition="@(context.Variables["pdv_token"] != null)">
                        <set-variable name="tokenPDV" value="@((string)context.Variables["pdv_token"])" />
                        <set-variable name="bypassCacheStorage" value="true" />
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="401" reason="Unauthorized" />
                        </return-response>
                    </otherwise>
                </choose>
                <!-- save token into cache -->
                <choose>
                    <when condition="@("true".Equals((string)context.Variables["bypassCacheStorage"]))">
                        <cache-store-value key="@((string)context.Variables["token"]+"-kc-idpay")" value="@((string)context.Variables["tokenPDV"])" duration="3600" />
                    </when>
                </choose>
            </when>
        </choose>
        <!-- setting userId variable -->
        <set-variable name="userId" value="@((string)context.Variables["tokenPDV"])" />
        <set-header name="x-user-id" exists-action="override">
            <value>@((string)context.Variables["userId"])</value>
        </set-header>
        <set-header name="X-Client-Channel" exists-action="override">
            <value>WEB</value>
        </set-header>

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
