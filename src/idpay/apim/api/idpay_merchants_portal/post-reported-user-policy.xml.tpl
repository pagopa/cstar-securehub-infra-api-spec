<policies>
  <inbound>
    <base />
    <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpaymerchant/" />
    <set-variable name="varUserIdFromValidToken" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("uid", ""))" />
    <set-header name="organization-user-id" exists-action="override">
      <value>@((string)context.Variables["varUserIdFromValidToken"])</value>
    </set-header>
    <!-- rewrite: /idpay/merchant/organization/{org_id}/reportedUser -->
    <rewrite-uri template="@("/idpay/merchant/organization/"+((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("org_id", "")+"/reportedUser")" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
    <choose>
      <when condition="@(context.Response.StatusCode >= 500)">
        <return-response>
          <set-status code="200" reason="OK" />
          <set-header name="Content-Type" exists-action="override"><value>application/json</value></set-header>
          <set-body>@{ return new JObject(
              new JProperty("status","KO"),
              new JProperty("errorKey","Service unavailable")
          ).ToString(); }</set-body>
        </return-response>
      </when>
    </choose>
    -->
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
