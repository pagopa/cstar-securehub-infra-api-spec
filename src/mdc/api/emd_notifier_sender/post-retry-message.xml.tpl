<policies>
  <inbound>
    <base />
    <choose>
      <when condition="@(((string)context.Variables[&quot;groups&quot;]) == &quot;emd-pagopa&quot;)">
        <set-backend-service base-url="${ingress_load_balancer_hostname}/emdnotifiersender" />
        <rewrite-uri template="/emd/notifier-sender/messages/retry" />
      </when>
      <otherwise>
        <return-response>
          <set-status code="401" reason="Operation Unauthorized" />
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
