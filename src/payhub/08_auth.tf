module "apim_api_auth" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-auth-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Servizio IAM di Piattaforma Unitaria"
  display_name = "AUTH API"
  path         = "payhub-auth"
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/p4paauth/payhub"

  content_format = "openapi"
  content_value = templatefile("./api/auth/_openapi.yaml", {
    hostname = "https://${local.apim_hostname}/payhub-auth"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
