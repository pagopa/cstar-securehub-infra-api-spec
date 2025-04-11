module "apim_api_mypay_landing" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-mypay-landing-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = "Landing di MyPay"
  display_name = "MyPay Landing"
  path         = local.context_path_mypay_landing
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/${local.context_path_mypay_landing}"

  content_format = "openapi"
  content_value = templatefile("./api/mypay_landing/_openapi.json", {
    hostname = "https://${local.apim_hostname}/${local.context_path_mypay_landing}"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
