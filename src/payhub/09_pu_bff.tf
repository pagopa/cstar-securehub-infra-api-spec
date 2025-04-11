module "apim_pu_bff" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-pu-bff"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Servizio BFF per Piattaforma Unitaria"
  display_name = "BFF API"
  path         = "pu"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/p4papubff"

  content_format = "openapi"
  content_value = templatefile("./api/p4pa_pu_bff/_openapi.yaml", {
    hostname = "https://${local.apim_hostname}/pu-bff"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
