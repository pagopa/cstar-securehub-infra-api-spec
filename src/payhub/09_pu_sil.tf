module "apim_pu_sil" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-pu-sil"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Servizio sil per Piattaforma Unitaria"
  display_name = "Sil API"
  path         = "pu-sil"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/p4papusil"

  content_format = "openapi"
  content_value = templatefile("./api/p4pa_pu_sil/_openapi.yaml", {
    hostname = "https://${local.apim_hostname}/pu-sil"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
