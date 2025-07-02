resource "azurerm_api_management_api" "auth" {
  name                = "${local.project}-auth-itn"
  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name
  api_management_name = data.azurerm_api_management.apim_core.name
  revision            = "1"
  display_name        = "McShared Auth ITN"
  description         = "Authorization Microservice"
  path                = "auth-itn"
  protocols           = ["https"]
  service_url         = "https://keycloak.itn.${var.dns_zone_internal_prefix}.${var.external_domain}"

  subscription_required = false

  import {
    content_format = "openapi"
    content_value  = file("./apim/api/oidc/openapi.yaml")
  }
}

resource "azurerm_api_management_product_api" "auth" {
  product_id          = data.azurerm_api_management_product.mcshared.product_id
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name
}

resource "azurerm_api_management_api_policy" "rtp_activation_product_policy" {
  api_name            = azurerm_api_management_api.auth.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name

  xml_content = templatefile("./apim/api/base_policy.xml", {})

  depends_on = [azurerm_api_management_api.auth]
}
