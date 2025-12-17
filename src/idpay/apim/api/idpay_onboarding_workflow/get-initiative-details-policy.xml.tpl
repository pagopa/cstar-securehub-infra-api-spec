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
        <!-- INBOUND: rewrite to /status -->
        <set-variable name="initiativeId" value="@((string)context.Request.MatchedParameters["initiativeId"])" />
        <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpayonboardingworkflow" />
        <rewrite-uri template="@("idpay/onboarding/{initiativeId}/"+ (string)context.Variables["tokenPDV"]+"/status")" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
        <choose>
            <!-- 1) if status respond 404 => call /detail cached -->
            <when condition="@((int)context.Response.StatusCode == 404)">
                <choose>
                    <!-- check onboarding allowed before cutoff -->
                    <when condition="@(context.Timestamp < new DateTime(2026, 1, 1, 0, 0, 0, DateTimeKind.Utc))">
                        <set-variable name="initiativeId" value="@((string)context.Request.MatchedParameters["initiativeId"])" />
                        <set-variable name="detailsCacheKey" value="@("details:" + (string)context.Variables["initiativeId"])" />
                        <set-variable name="cachedDetails" value="" />
                        <cache-lookup-value key="@((string)context.Variables["detailsCacheKey"])" variable-name="cachedDetails" />
                        <choose>
                            <!-- HIT cache -->
                            <when condition="@(!string.IsNullOrEmpty((string)context.Variables["cachedDetails"]))">
                                <return-response>
                                    <set-header name="Content-Type" exists-action="override">
                                        <value>application/json; charset=utf-8</value>
                                    </set-header>
                                    <set-header name="Cache-Control" exists-action="override">
                                        <value>no-store</value>
                                    </set-header>
                                    <set-body>@{
                                        return (string)context.Variables["cachedDetails"];
                                        }
                                    </set-body>
                                </return-response>
                            </when>
                            <!-- MISS cache -->
                            <otherwise>
                                <send-request mode="new" response-variable-name="detailsResp" timeout="10" ignore-error="false">
                            <set-url>@("https://${ingress_load_balancer_hostname}/idpayonboardingworkflow/idpay/onboarding/"
                    + Uri.EscapeDataString((string)context.Variables["initiativeId"]) + "/detail")</set-url>
                                    <set-method>GET</set-method>
                                </send-request>
                                <cache-store-value key="@((string)context.Variables["detailsCacheKey"])" value="@(((IResponse)context.Variables["detailsResp"]).Body.As<string>(preserveContent:true))" duration="3600" />
                                <return-response response-variable-name="detailsResp" />
                            </otherwise>
                        </choose>
                    </when>
                    <otherwise>
                        <return-response>
                            <set-status code="400" reason="Not Found" />
                            <set-header name="Content-Type" exists-action="override">
                                <value>application/json; charset=utf-8</value>
                            </set-header>
                            <set-header name="Cache-Control" exists-action="override">
                                <value>no-store</value>
                            </set-header>
                            <set-body>@{
                            var payload = new JObject(
                                new JProperty("code", "ONBOARDING_INITIATIVE_ENDED"),
                                new JProperty("message", "Onboarding not allowed after 01/01/2026")
                            );
                            return payload.ToString(Newtonsoft.Json.Formatting.None);
                            }</set-body>
                        </return-response>
                    </otherwise>
                </choose>
            </when>
            <!-- 2) Not 404 response from /status: if status = ON_EVALUATION o ONBOARDING_OK, update code/message -->
            <otherwise>
                <!-- save status variable -->
                <set-variable name="userStatus" value="@{
        var jo = context.Response.Body.As<JObject>(preserveContent: true);
        var tok = jo?["status"];
        return ((string)tok ?? string.Empty).ToUpperInvariant();
      }" />
                <choose>
                    <when condition="@(((string)context.Variables["userStatus"] == "ON_EVALUATION")
                         || ((string)context.Variables["userStatus"] == "ONBOARDING_OK"))">
                        <return-response>
                            <set-status code="400" />
                            <set-header name="Content-Type" exists-action="override">
                                <value>application/json; charset=utf-8</value>
                            </set-header>
                            <set-header name="Cache-Control" exists-action="override">
                                <value>no-store</value>
                            </set-header>
                            <set-body>@{
              var s = (string)context.Variables["userStatus"];
              var code = s == "ON_EVALUATION" ? "ONBOARDING_ON_EVALUATION" : "ONBOARDING_ALREADY_ONBOARDED";
              // define payload with updated code
              var payload = new JObject(
                new JProperty("code", code),
                new JProperty("message", "")
              );
              return payload.ToString(Newtonsoft.Json.Formatting.None);
            }</set-body>
                        </return-response>
                    </when>
                    <!-- other: pass-throught /status response -->
                    <otherwise />
                </choose>
            </otherwise>
        </choose>
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
