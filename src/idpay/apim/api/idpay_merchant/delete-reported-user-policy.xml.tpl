<policies>
  <inbound>
    <base />
    <set-backend-service base-url="https://${ingress_load_balancer_hostname}/idpaymerchant/" />
    <set-variable name="varUserIdFromValidToken" value="@(((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("uid", ""))" />
    <set-header name="organization-user-id" exists-action="override">
      <value>@((string)context.Variables["varUserIdFromValidToken"])</value>
    </set-header>
    <rewrite-uri
      template="@(
        "/idpay/merchant/organization/"
        + ((Jwt)context.Variables["validatedToken"]).Claims.GetValueOrDefault("org_id", "")
        + "/reportedUser/"
        + Uri.EscapeDataString((string)context.Request.MatchedParameters.GetValueOrDefault("userFiscalCode",""))
      )"
      copy-unmatched-parameters="true" />
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
