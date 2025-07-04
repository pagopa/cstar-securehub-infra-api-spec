data "azurerm_api_management_user" "idpay_apim_user_mocked_acquirer" {
  count = var.enable_flags.mocked_merchant ? 1 : 0

  user_id             = var.idpay_mocked_acquirer_apim_user_id
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
}

resource "azurerm_api_management_subscription" "idpay_apim_subscription_mocked_acquirer" {
  count = var.enable_flags.mocked_merchant ? 1 : 0

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  user_id             = data.azurerm_api_management_user.idpay_apim_user_mocked_acquirer[0].id
  product_id          = module.idpay_itn_api_acquirer_product.id
  display_name        = "Mocked Acquirer"
  allow_tracing       = false
  state               = "active"
}

resource "azurerm_api_management_named_value" "idpay_apim_subscription_mocked_acquirer_key" {
  count = var.enable_flags.mocked_merchant ? 1 : 0

  name                = "itn-mocked-acquirer-subscription-key"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "ItnMockedAcquirerSubscriptionKey"
  value               = azurerm_api_management_subscription.idpay_apim_subscription_mocked_acquirer[0].primary_key
  secret              = true
}

#
# IDPAY PRODUCTS
#
module "idpay_api_merchant_mock_product" {
  count = var.enable_flags.mocked_merchant ? 1 : 0

  depends_on = [azurerm_api_management_named_value.idpay_apim_subscription_mocked_acquirer_key]

  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_merchant_mock_product"
  display_name = "IDPAY_ITN_MERCHANT_MOCK_PRODUCT"
  description  = "IDPAY_ITN_MERCHANT_MOCK_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = file("./apim/api_product/acquirer/policy_mock_merchant.xml")

  groups = ["developers"]

}

#
# IDPAY API
#

## IDPAY QR-Code payment MOCK MERCHANT API ##
module "idpay_qr_code_payment_mock_merchant" {
  count = var.enable_flags.mocked_merchant ? 1 : 0

  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-qr-code-payment-mock-merchant"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN QR-CODE PAYMENT MOCK MERCHANT"
  display_name = "IDPAY ITN QR-CODE PAYMENT MOCK MERCHANT API"
  path         = "idpay-itn/payment/qr-code/mock/merchant"
  protocols    = ["https"]

  service_url = "https://api-io.${data.azurerm_dns_zone.public.name}/idpay/payment/qr-code/merchant"

  content_format = "openapi"
  content_value  = templatefile("./apim/api/idpay_qrcode_payment/acquirer/openapi.qrcode_payment_test_merchant.yml.tpl", {})

  xml_content = templatefile("./apim/api/idpay_qrcode_payment/acquirer/mock_merchant_base_policy.xml", {
    origins = local.origins.base
  })

  product_ids = [module.idpay_api_merchant_mock_product[0].product_id]

}
