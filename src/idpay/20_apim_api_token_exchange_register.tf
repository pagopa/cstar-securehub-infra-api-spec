
resource "azurerm_api_management_certificate" "idpay_register_token_exchange_cert_jwt" {
  name                = "${local.project}-register-token-exchange-jwt"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  key_vault_secret_id = data.azurerm_key_vault_certificate.idpay_register_jwt_signing_cert.versionless_secret_id
}

resource "azurerm_api_management_api" "idpay_register_token_exchange" {
  name                = "${var.env_short}-idpay-itn-token-exchange-register"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  display_name          = "IDPAY ITN Token Exchange for Register Portal"
  path                  = "idpay-itn/register/token"
  subscription_required = false
  #service_url          = ""
  protocols = ["https"]

}

resource "azurerm_api_management_api_operation" "idpay_register_token_exchange" {
  operation_id        = "idpay-token-exchange-register"
  api_name            = azurerm_api_management_api.idpay_register_token_exchange.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token Exchange for Register Portal"
  method              = "POST"
  url_template        = "/"
  description         = "Endpoint for selfcare token exchange towards register portal"
}

resource "azurerm_api_management_named_value" "selfcare_api_key" {
  name                = "${var.env_short}-${local.prefix_api}-selfcare-api-key"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "${var.env_short}-${local.prefix_api}-selfcare-api-key"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.selfcare-api-key.versionless_id
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_register_token_exchange_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_register_token_exchange.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_register_token_exchange.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_register_token_exchange.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_register_token_exchange.operation_id

  xml_content = templatefile("./apim/api/idpay_token_exchange/jwt_exchange_register.xml.tpl", {
    openid-config-url           = local.idpay-oidc-config_url,
    selfcare-issuer             = local.selfcare-issuer,
    jwt_cert_signing_thumbprint = azurerm_api_management_certificate.idpay_register_token_exchange_cert_jwt.thumbprint,
    idpay-portal-hostname       = local.idpay-register-hostname,
    origins                     = local.origins.base
    selfcare_api_key_reference  = azurerm_api_management_named_value.selfcare_api_key.display_name,
    invitalia_fc                = var.invitalia_fc,
    selfcare_base_url           = var.selfcare_base_url,
    idpay-allowed-institutions  = join(",", var.allowed_institutions)
  })


}

resource "azurerm_api_management_api_operation" "idpay_register_token_exchange_test" {
  count               = var.env_short != "p" ? 1 : 0
  operation_id        = "idpay_token_exchange_register_test"
  api_name            = azurerm_api_management_api.idpay_register_token_exchange.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token Exchange for Register Portal test"
  method              = "POST"
  url_template        = "/test"
  description         = "Endpoint for selfcare token exchange towards register portal test"
}

resource "azurerm_api_management_api_operation_policy" "idpay_register_token_exchange_policy_test" {
  count               = var.env_short != "p" ? 1 : 0
  api_name            = azurerm_api_management_api_operation.idpay_register_token_exchange_test[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_register_token_exchange_test[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_register_token_exchange_test[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_register_token_exchange_test[0].operation_id

  xml_content = templatefile("./apim/api/idpay_token_exchange/jwt_register_token_test.xml.tpl", {
    ingress_load_balancer_hostname = local.domain_aks_ingress_hostname,
    jwt_cert_signing_thumbprint    = azurerm_api_management_certificate.idpay_register_token_exchange_cert_jwt.thumbprint
    origins                        = local.origins.base
  })

}
