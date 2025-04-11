module "apim_api_mypay" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-mypay-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Sistema di gestione dei pagamenti"
  display_name = "MyPay API"
  path         = "payhub"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/payhub"

  content_format = "openapi"
  content_value = templatefile("./api/mypay/_openapi.yaml", {
    hostname = "https://${local.apim_hostname}/payhub"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}

module "apim_api_mypay_sil" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-mypay-sil-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Sistema di gestione dei pagamenti Sil"
  display_name = "MyPay SIL API"
  path         = "payhub/sil"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/payhub/sil"

  content_format = "openapi"
  content_value = templatefile("./api/mypay/_openapi_sil.yaml", {
    hostname = "https://${local.apim_hostname}/payhub/sil"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
