module "apim_well_known" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-well-known"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Well-Known"
  display_name = "Well-Known"
  path         = "well-known"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/p4paauth/payhub/.well-known"

  content_format = "openapi"
  content_value = templatefile("./api/auth/wellknown.openapi.yaml", {
    hostname = "https://${local.apim_hostname}"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
