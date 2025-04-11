module "apim_api_pa_for_node" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-pa-for-node-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_payhub_product.product_id]
  subscription_required = false
  version_set_id        = null
  api_version           = null

  description  = ""
  display_name = "PaForNode"
  path         = local.context_path_pa_for_node
  protocols    = ["https"]
  service_url  = "${local.ingress_endpoint}/${replace(local.context_path_pa_for_node, "payhub", "p4papagopapayments")}"
  api_type     = "soap"

  content_format = "wsdl"
  content_value = templatefile("./api/paForNode/paForNode.wsdl", {
    hostname = "https://${local.apim_hostname}/${local.context_path_pa_for_node}"
  })

  xml_content = templatefile("./api/_base_policy.xml", {})
}
