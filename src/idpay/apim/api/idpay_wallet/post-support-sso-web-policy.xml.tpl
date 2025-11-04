<policies>
  <inbound>
    <base />
    <set-backend-service base-url="https://{{ingress_load_balancer_hostname}}" />
    <rewrite-uri template="/idpaywallet/idpay/wallet/support" />
    <set-header name="Content-Type" exists-action="override">
      <value>application/json</value>
    </set-header>
  </inbound>

  <backend>
    <base />
  </backend>

  <outbound>
    <base />
    <set-header name="Content-Type" exists-action="override">
      <value>text/html; charset=utf-8</value>
    </set-header>
  </outbound>

  <on-error>
    <base />
  </on-error>
</policies>
