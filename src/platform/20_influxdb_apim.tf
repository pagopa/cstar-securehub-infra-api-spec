#
# PLATFORM PRODUCTS
#

module "platform_influxdb_product" {
  source = "./.terraform/modules/__v4__/api_management_product"

  product_id   = "influxdb"
  display_name = "Influxdb"
  description  = "Product Influxdb"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  policy_xml = file("./apim/api_product/influxdb/_base_policy.xml")

  groups = ["developers"]
}

#
# PLATFORM APIS
#

locals {
  platform_influxdb_api = {
    display_name          = "Influxdb2 - API"
    description           = "API to influxdb v2"
    path                  = ""
    subscription_required = false
    service_url           = var.env == "prod" ? "influxdb.itn.internal.cstar.pagopa.it" : "influxdb.itn.${var.env}.internal.cstar.pagopa.it"
  }
}

module "platform_influxdb_api_v2" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${local.project}-influxdb2-api"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = local.platform_influxdb_api.description
  display_name = local.platform_influxdb_api.display_name
  path         = local.platform_influxdb_api.path
  protocols    = ["https"]

  service_url = local.platform_influxdb_api.service_url

  content_format = "openapi"
  content_value = templatefile("./apim/api/influxdb/_openapi.json.tpl", {
    host = local.platform_influxdb_api.service_url
  })

  xml_content = templatefile("./apim/api/influxdb/_base_policy.xml", {
    hostname = local.platform_influxdb_api.service_url
  })

  product_ids           = [module.platform_influxdb_product.product_id]
  subscription_required = local.platform_influxdb_api.subscription_required
}
