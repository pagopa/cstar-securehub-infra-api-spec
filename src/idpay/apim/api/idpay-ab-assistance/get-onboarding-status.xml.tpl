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

    <set-variable name="apiKey" value="@(context.Request.Headers.GetValueOrDefault("x-api-key", ""))" />

    <choose>
      <when condition="@(!context.Variables.ContainsKey("apiKey") || string.IsNullOrEmpty((string)context.Variables["apiKey"]))">
        <return-response>
          <set-status code="401" reason="Unauthorized" />
          <set-body>{
            "code": "API_KEY_MISSING",
            "message": "API Key mancante nella richiesta"
          }</set-body>
        </return-response>
      </when>
      <when condition="@((string)context.Variables["apiKey"] != "{{${assistance_api_key_reference}}}")">
        <return-response>
          <set-status code="403" reason="Forbidden" />
          <set-body>{
            "code": "INVALID_API_KEY",
            "message": "API Key non valida"
          }</set-body>
        </return-response>
      </when>
    </choose>

    <set-variable name="requestBody" value="@((JObject)context.Request.Body.As<JObject>(preserveContent: true))" />

    <set-variable name="fiscalCode" value="@( (string)context.Variables.GetValueOrDefault("requestBody")?["fiscalCode"] )" />

    <choose>
      <when condition="@(!context.Variables.ContainsKey("fiscalCode") || string.IsNullOrEmpty((string)context.Variables["fiscalCode"]))">
        <return-response>
          <set-status code="400" reason="Bad Request" />
          <set-body>{
          "code": "CF_MISSING",
          "message": "Codice fiscale mancante nella richiesta"
          }
          </set-body>
        </return-response>
      </when>
    </choose>

    <set-variable name="pii" value="@((string)context.Variables["fiscalCode"])" />

    <include-fragment fragment-id="idpay-datavault-tokenizer" />

    <choose>
      <when condition="@(!context.Variables.ContainsKey("pdv_token") || string.IsNullOrEmpty((string)context.Variables["pdv_token"]))">
        <return-response>
          <set-status code="502" reason="Tokenization Failed" />
          <set-body>{
          "code": "TOKENIZATION_ERROR",
          "message": "Impossibile ottenere il token PDV dal DataVault"
          }
          </set-body>
        </return-response>
      </when>
    </choose>

    <set-variable name="tokenPDV" value="@((string)context.Variables["pdv_token"])" />

    <rewrite-uri template="@("/idpay/assistance/onboardings/status/68dd003ccce8c534d1da22bc/" + (string)context.Variables["tokenPDV"])" />

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
