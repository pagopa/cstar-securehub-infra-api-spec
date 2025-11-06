
resource "azurerm_api_management_named_value" "ab_assistance_api_key_reference" {
  name                = "${var.env_short}-${local.prefix_api}-ab-assistance-api-key"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "${var.env_short}-${local.prefix_api}-ab-assistance-api-key"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.ab-asistance-api-key.versionless_id
  }
}

resource "azurerm_api_management_api" "idpay_ab_assistance" {
  name                = "${var.env_short}-idpay-itn-ab-assistance"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  display_name          = "IDPAY ITN Appliances Bonus Assistance"
  path                  = "idpay-itn/ab/assistance"
  subscription_required = false
  protocols             = ["https"]

}

resource "azurerm_api_management_api_operation" "idpay_ab_voucher_status" {
  operation_id        = "idpay-ab-voucher-status"
  api_name            = azurerm_api_management_api.idpay_ab_assistance.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Appliances Bonus Voucher Status"
  method              = "POST"
  url_template        = "/voucher/status"
  description         = "Returns information about a voucher by knowing the beneficiary's tax code"
}


resource "azurerm_api_management_api_operation_policy" "idpay_ab_voucher_status_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_ab_voucher_status.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_ab_voucher_status.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_ab_voucher_status.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_ab_voucher_status.operation_id

  xml_content = templatefile("./apim/api/idpay-ab-assistance/get-voucher-status.xml.tpl", {
    assistance_api_key_reference = azurerm_api_management_named_value.ab_assistance_api_key_reference.display_name
  })
}


resource "azurerm_api_management_api_operation" "idpay_ab_onboarding_status" {
  operation_id        = "idpay-ab-onboarding-status"
  api_name            = azurerm_api_management_api.idpay_ab_assistance.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Appliances Bonus Voucher Status"
  method              = "POST"
  url_template        = "/onboarding/status"
  description         = "Returns information about a onboarding request by knowing the beneficiary's tax code"
}


resource "azurerm_api_management_api_operation_policy" "idpay_ab_onboarding_status" {
  api_name            = azurerm_api_management_api_operation.idpay_ab_onboarding_status.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_ab_onboarding_status.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_ab_onboarding_status.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_ab_onboarding_status.operation_id

  xml_content = templatefile("./apim/api/idpay-ab-assistance/get-onboarding-status.xml.tpl", {
    assistance_api_key_reference = azurerm_api_management_named_value.ab_assistance_api_key_reference.display_name
  })
}
