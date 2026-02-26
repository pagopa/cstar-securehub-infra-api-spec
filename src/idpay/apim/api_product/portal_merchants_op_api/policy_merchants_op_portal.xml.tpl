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
            <!-- JWT validation with OpenID Connect -->
            <validate-jwt header-name="Authorization" failed-validation-httpcode="401" failed-validation-error-message="Unauthorized. Access token is missing or invalid." output-token-variable-name="validatedToken">
                <openid-config url="${openid_config_url_merchant_op}" />
              <required-claims>
                <claim name="iss">
                  <value>${keycloak_url_merchant_op}</value>
                </claim>
              </required-claims>
            </validate-jwt>

        <set-variable name="azp" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("azp", ""))" />
        <choose>
            <when condition="@((string)context.Variables["azp"] != "${merchant_op_client_id}" && (string)context.Variables["azp"] != "${merchant_op_client_id_test}")">
                <return-response>
                    <set-status code="401" reason="Unauthorized" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>{"statusCode":401,"message":"Unauthorized. Invalid azp claim."}</set-body>
                </return-response>
            </when>
        </choose>

        <set-variable name="merchantId" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("merchant_id", ""))" />
        <set-header name="x-merchant-id" exists-action="override">
            <value>@((String)context.Variables["merchantId"])</value>
        </set-header>
        <set-variable name="pointOfSaleId" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("point_of_sale_id", ""))" />
        <set-header name="x-point-of-sale-id" exists-action="override">
            <value>@((String)context.Variables["pointOfSaleId"])</value>
        </set-header>
        <set-variable name="merchantRole" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("point_of_sale_id", "") != "" ? "MERCHANT_OP" : "MERCHANT")" />
        <set-header name="x-merchant-role" exists-action="override">
            <value>@((String)context.Variables["merchantRole"])</value>
        </set-header>
        <set-header name="x-acquirer-id" exists-action="override">
            <value>PAGOPA</value>
        </set-header>

        <rate-limit calls="${rate_limit_merchants_portal}" renewal-period="60" />
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
