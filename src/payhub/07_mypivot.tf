module "apim_api_mypivot" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-mypivot-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Sistema di gestione delle riconciliazioni contabili dei pagamenti"
  display_name = "MyPivot API"
  path         = "payhubpivot"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/payhubpivot"

  content_format = "openapi"
  content_value = templatefile("./api/mypivot/_openapi.yaml", {
    hostname = "https://${local.apim_hostname}/payhubpivot"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}

module "apim_api_mypivot_sil" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-mypivot-sil-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Sistema di gestione delle riconciliazioni contabili dei pagamenti SIL"
  display_name = "MyPivot SIL API"
  path         = "payhubpivot/sil"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/payhubpivot/sil"

  content_format = "openapi"
  content_value = templatefile("./api/mypivot/_openapi_sil.yaml", {
    hostname = "https://${local.apim_hostname}/payhubpivot/sil"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}