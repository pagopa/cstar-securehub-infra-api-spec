<!--
    - Policies are applied in the order they appear.
    - Position <base/> inside a section to inherit policies from the outer scope.
    - Comments within policies are not preserved.
-->
<!-- Add policies as children to the <inbound>, <outbound>, <backend>, and <on-error> elements -->
<policies>
    <inbound>
        <base />
        <choose>
            <when condition="@(context.Variables.GetValueOrDefault("organizationRole", "") != "invitalia")">
                <return-response>
                    <set-status code="403" reason="Forbidden" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                </return-response>
            </when>
        </choose>
        <send-request mode="new" response-variable-name="institutionsResponse" timeout="10" ignore-error="false">
            <set-url>@("${selc_base_url}"+"/external/v2/tokens/products/prod-registro-beni?status=COMPLETED")</set-url>
            <set-method>GET</set-method>
            <set-header name="Ocp-Apim-Subscription-Key" exists-action="override">
                <value>{{${selfcare_api_key_reference}}}</value>
            </set-header>
        </send-request>
        <choose>
            <when condition="@(context.Variables["institutionsResponse"] == null)">
                <return-response>
                    <set-status code="504" reason="Institutions API Gateway Timeout" />
                </return-response>
            </when>
            <when condition="@(((IResponse)context.Variables["institutionsResponse"]).StatusCode == 200)">
                <return-response>
                    <set-status code="200" />
                    <set-header name="Content-Type" exists-action="override">
                        <value>application/json</value>
                    </set-header>
                    <set-body>@{
                        var json = ((IResponse)context.Variables["institutionsResponse"]).Body.As<JObject>();
                        var items = json["items"] as JArray;

                        var resultArray = new JArray();

                        foreach (var item in items)
                        {
                          if((string)item["institutionId"] != (string)context.Variables["organizationId"]){
                            var resultItem = new JObject
                            {
                                ["institutionId"] = item["institutionId"] ?? "N/A",
                                ["createdAt"] = item["createdAt"] ?? "N/A",
                                ["updatedAt"] = item["updatedAt"] ?? "N/A",
                                ["description"] = item["institutionUpdate"]?["description"] ?? "N/A",
                            };
                            resultArray.Add(resultItem);
                          }
                        }

                        return new JObject{
                            ["institutions"] = resultArray
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
