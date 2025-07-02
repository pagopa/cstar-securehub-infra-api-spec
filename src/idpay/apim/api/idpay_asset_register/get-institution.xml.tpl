<!--
    - Policies are applied in the order they appear.
    - Position <base/> inside a section to inherit policies from the outer scope.
    - Comments within policies are not preserved.
-->
<!-- Add policies as children to the <inbound>, <outbound>, <backend>, and <on-error> elements -->
<policies>
    <inbound>
        <base />
        <set-variable name="institutionId" value="@(context.Request.MatchedParameters["institutionId"])" />
        <send-request mode="new" response-variable-name="institutionResponse" timeout="10" ignore-error="false">
            <set-url>@("${selc_base_url}"+"/external/v2/institutions/"+context.Variables["institutionId"])</set-url>
           <set-method>GET</set-method>
            <set-header name="Ocp-Apim-Subscription-Key" exists-action="override">
                <value>{{${selfcare_api_key_reference}}}</value>
            </set-header>
        </send-request>
        <choose>
            <when condition="@(context.Variables["institutionResponse"] == null)">
                <return-response>
                    <set-status code="504" reason="Institutions API Gateway Timeout" />
                </return-response>
            </when>
            <when condition="@(((IResponse)context.Variables["institutionResponse"]).StatusCode == 200)">
                <return-response>
                    <set-status code="200" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                            var json = ((IResponse)context.Variables["institutionResponse"]).Body.As<JObject>();
                            return new JObject {
                                ["address"] = json["address"],
                                ["city"] = json["city"],
                                ["county"] = json["county"],
                                ["country"] = json["country"],
                                ["zipCode"] = json["zipCode"],
                                ["digitalAddress"] = json["digitalAddress"],
                                ["description"] = json["description"],
                                ["taxCode"] = json["taxCode"],
                                ["externalId"] = json["externalId"]
                            }.ToString();
                        }</set-body>
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