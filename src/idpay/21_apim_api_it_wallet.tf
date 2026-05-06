#
# IDPAY PRODUCTS
#

module "idpay_itn_api_portal_it_wallet_product" {
  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_portal_it_wallet_product"
  display_name = "IDPAY_ITN_APP_PORTAL_IT_WALLET_PRODUCT"
  description  = "IDPAY_ITN_APP_PORTAL_IT_WALLET_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./apim/api_product/it_wallet/policy_it_wallet.xml.tpl", {
    origins                     = local.origins_bonus_elettrodomestici.base
    rate_limit_it_wallet_portal = var.rate_limit_it_wallet_portal_product
    keycloak_timeout_sec        = var.keycloak_timeout_sec
    env_short                   = var.env_short
  })

  groups = ["developers"]

  depends_on = [
    azurerm_api_management_named_value.pdv_api_key
  ]

}

## IDPAY IT WALLET API ##
module "idpay_itn_it_wallet_api" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-it-wallet-portal"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN IT Wallet API"
  display_name = "IDPAY ITN IT Wallet API"
  path         = "idpay-itn/it-wallet"
  protocols    = ["https"]

  # Service URL aligned with the OpenAPI servers in the spec (Development environment)
  service_url = "https://api-io.dev.cstar.pagopa.it/idpay-itn/it-wallet"

  content_format = "openapi"
  # load the OpenAPI specification for IT Wallet
  content_value = file("./apim/api/idpay_it_wallet/openapi.it.wallet.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_it_wallet_product.product_id]
  subscription_required = false
}
