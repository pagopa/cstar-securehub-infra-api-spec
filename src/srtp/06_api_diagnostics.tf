resource "azurerm_api_management_api_diagnostic" "this" {
  for_each = local.apis

  identifier               = "applicationinsights"
  resource_group_name      = local.apim_rg_name
  api_management_name      = local.apim_name
  api_name                 = azurerm_api_management_api.this[each.key].name
  api_management_logger_id = local.apim_logger_id

  always_log_errors         = lookup(lookup(each.value, "api_diagnostic", {}), "always_log_errors", true)
  verbosity                 = lookup(lookup(each.value, "api_diagnostic", {}), "verbosity", "error")
  sampling_percentage       = lookup(lookup(each.value, "api_diagnostic", {}), "sampling_percentage", 5.0)
  http_correlation_protocol = lookup(lookup(each.value, "api_diagnostic", {}), "http_correlation_protocol", "W3C")
  log_client_ip             = lookup(lookup(each.value, "api_diagnostic", {}), "log_client_ip", false)

  dynamic "frontend_request" {
    for_each = lookup(lookup(each.value, "api_diagnostic", {}), "headers_to_log", []) != [] ? [1] : []
    content {
      headers_to_log = lookup(lookup(each.value, "api_diagnostic", {}), "headers_to_log", [])
    }
  }

  dynamic "backend_request" {
    for_each = lookup(lookup(each.value, "api_diagnostic", {}), "headers_to_log", []) != [] ? [1] : []
    content {
      headers_to_log = lookup(lookup(each.value, "api_diagnostic", {}), "headers_to_log", [])
    }
  }
}
