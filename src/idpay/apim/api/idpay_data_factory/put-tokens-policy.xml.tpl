<!--
    Data Factory -> mcshared-datavault tokenizer (CF -> userId), used by the onboarding census pipeline.
    Only PUT /tokens is exposed: detokenization (GET /tokens/{token}/pii) and DELETE are intentionally not routed.
    Retries are handled by the ADF Web Activity policy, not here.
-->
<policies>
    <inbound>
        <base />
        <set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />
        <set-header name="x-api-key" exists-action="override">
            <value>{{pdv-api-key}}</value>
        </set-header>
        <set-backend-service base-url="${mcshared_datavault_url}" />
        <rewrite-uri template="/tokens" copy-unmatched-params="false" />
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

