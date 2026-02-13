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
  subscription_required = false
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
  url_template        = "/initiatives/{initiativeId}/reports/{reportId}"
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
