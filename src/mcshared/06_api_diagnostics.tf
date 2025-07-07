resource "azurerm_api_management_api_diagnostic" "this" {
  for_each = {
    for k, api in local.apis : k => api if contains(keys(api), "api_diagnostic")
  }

  identifier               = "applicationinsights"
  resource_group_name      = local.apim_rg_name
  api_management_name      = local.apim_name
  api_name                 = azurerm_api_management_api.this[each.key].name
  api_management_logger_id = local.apim_logger_id

  always_log_errors = each.value.api_diagnostic.always_log_errors
  verbosity         = each.value.api_diagnostic.verbosity

}
