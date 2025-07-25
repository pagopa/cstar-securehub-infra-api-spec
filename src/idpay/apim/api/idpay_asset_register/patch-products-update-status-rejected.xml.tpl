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
        <choose>
            <when condition="@(context.Variables.GetValueOrDefault("organizationRole", "") == "invitalia")">
                <set-header name="x-organization-id" exists-action="override">
                    <value>@((String)context.Request.Headers["x-organization-selected"].FirstOrDefault())</value>
                </set-header>
            </when>
        </choose>
        <set-variable name="requestBody" value="@((JObject)context.Request.Body.As<JObject>())" />
        <set-variable name="modifiedBody" value="@{
            var body = context.Variables["requestBody"] as JObject;
            body["status"] = "REJECTED";
            return body.ToString();
        }" />

        <set-body template="none">@((string)context.Variables["modifiedBody"])</set-body>

        <rewrite-uri template="@("/idpay/register/products/update-status")" />
    </inbound>
</policies>
