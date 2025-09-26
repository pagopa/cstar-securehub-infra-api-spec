#
# PLATFORM PRODUCTS
#

module "platform_influxdb_product" {
  source = "./.terraform/modules/__v4__/api_management_product"

  product_id   = "influxdb"
  display_name = "Influxdb"
  description  = "Prodotto Influxdb"

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
    path                  = "shared/influxdb"
    subscription_required = false
    service_url           = null
  }
}

module "platform_influxdb_api_v2" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = format("%s-influxdb2-api", local.project)
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = local.platform_influxdb_api.description
  display_name = local.platform_influxdb_api.display_name
  path         = local.platform_influxdb_api.path
  protocols    = ["https"]

  service_url = local.platform_influxdb_api.service_url

  content_format = "openapi"
  content_value = templatefile("./apim/api/influxdb/v2/_openapi.json.tpl", {
    host = local.apim_hostname
  })

  xml_content = templatefile("./apim/api/influxdb/v2/_base_policy.xml", {
    hostname = local.shared_hostname
  })

  product_ids           = [module.platform_influxdb_product.product_id]
  subscription_required = local.platform_influxdb_api.subscription_required
}
