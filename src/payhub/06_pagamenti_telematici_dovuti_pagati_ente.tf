module "apim_api_pagamenti_telematici_dovuti_pagati_ente" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-pagamenti-telematici-dovuti-pagati-ente-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = ""
  display_name = "Pagamenti Telematici Dovuti Pagati per Ente"
  path         = local.context_path_pag_tel_dp_ente
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/${local.context_path_pag_tel_dp_ente}"
  api_type     = "soap"

  content_format = "wsdl"
  content_value = templatefile("./api/pagamenti_telematici_dovuti_pagati_ente/pa-per-ente.wsdl", {
    hostname = "https://${local.apim_hostname}/${local.context_path_pag_tel_dp_ente}"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
