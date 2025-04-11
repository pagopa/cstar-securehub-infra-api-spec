locals {
  apim_api_diagnostics = [
    module.apim_api_mypay.name,
    module.apim_api_mypay_landing.name,
    module.apim_api_pagamenti_telematici_CCP.name,
    module.apim_api_pagamenti_telematici_CCP36.name,
    module.apim_api_pagamenti_telematici_dovuti_pagati_ente.name,
    module.apim_api_pagamenti_telematici_pagati_riconciliati_ente.name,
    module.apim_api_pagamenti_telematici_RT.name,
    module.apim_api_mypivot.name,
  ]
}

resource "azurerm_api_management_api_diagnostic" "apim_api_diagnostics" {
  for_each = var.apim_diagnostics_enabled ? toset(local.apim_api_diagnostics) : []

  identifier               = "applicationinsights"
  resource_group_name      = local.apim_rg
  api_management_name      = local.apim_name
  api_name                 = each.key
  api_management_logger_id = local.apim_logger_id

  always_log_errors = true
  verbosity         = "information"

  frontend_request {
    headers_to_log = [
      "X-Forwarded-For"
    ]
  }
}