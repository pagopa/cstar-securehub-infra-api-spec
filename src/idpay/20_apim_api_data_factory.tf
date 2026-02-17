# #
# # IDPAY PRODUCT for internal use from data factory
# #
#
module "idpay_data_factory_product" {
  source = "./.terraform/modules/__v4__/api_management_product"

  product_id   = "idpay-itn-data-factory"
  display_name = "IDPAY ITN Data Factory"
  description  = "IDPAY ITN Data Factory"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = true
  approval_required     = false
}

# #
# # IDPAY API for internal use from data factory
# #
#

resource "azurerm_api_management_api" "idpay_data_factory" {
  name                = "${var.env_short}-idpay-itn-data-factory"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  display_name          = "IDPAY ITN Data Factory"
  path                  = "idpay-itn/df"
  subscription_required = true
  #service_url           = ""
  protocols = ["https"]

}

resource "azurerm_api_management_api_operation" "idpay_df_report_patch" {
  operation_id        = "idpay-df-report-patch"
  api_name            = azurerm_api_management_api.idpay_data_factory.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY DF Report Patch"
  method              = "PATCH"

  url_template = "/initiatives/{initiativeId}/reports/{reportId}"
  template_parameter {
    name     = "initiativeId"
    type     = "string"
    required = true
  }
  template_parameter {
    name     = "reportId"
    type     = "string"
    required = true
  }
  description = "Endpoint for DF in order to perform a report patch for update the status"
}

resource "azurerm_api_management_api_operation_policy" "idpay_df_report_patch_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_df_report_patch.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_df_report_patch.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_df_report_patch.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_df_report_patch.operation_id

  xml_content = templatefile("./apim/api/idpay_data_factory/patch-report-policy.xml.tpl", {
    ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
  })
}

resource "azurerm_api_management_product_api" "idpay_df_product_api" {
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  product_id = module.idpay_data_factory_product.product_id
  api_name   = azurerm_api_management_api.idpay_data_factory.name

  depends_on = [
    module.idpay_data_factory_product,
    azurerm_api_management_api.idpay_data_factory
  ]
}

resource "azurerm_api_management_subscription" "idpay_df_sub" {
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "${var.env_short}-idpay-df-sub"
  state        = "active"
  product_id   = module.idpay_data_factory_product.id
  depends_on   = [module.idpay_data_factory_product, azurerm_api_management_product_api.idpay_df_product_api]
}

resource "azurerm_key_vault_secret" "idpay_df_subscription_key" {
  name         = "idpay-df-subscription-key"
  value        = azurerm_api_management_subscription.idpay_df_sub.primary_key
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id

  depends_on = [azurerm_api_management_subscription.idpay_df_sub]
}
