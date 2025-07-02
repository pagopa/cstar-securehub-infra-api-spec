resource "azurerm_api_management_api_diagnostic" "idpay_itn_apim_api_diagnostics" {

  identifier               = "applicationinsights"
  resource_group_name      = data.azurerm_resource_group.apim_rg.name
  api_management_name      = data.azurerm_api_management.apim_core.name
  api_name                 = azurerm_api_management_product_api.auth.api_name
  api_management_logger_id = local.apim_logger_id

  always_log_errors = true
  verbosity         = "information"

  # frontend_request {
  #   headers_to_log = [
  #     "X-Forwarded-For"
  #   ]
  # }
}
