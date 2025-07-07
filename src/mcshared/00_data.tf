data "azurerm_api_management_product" "mcshared" {
  product_id          = "mcshared"
  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name
  api_management_name = data.azurerm_api_management.apim_core.name
}

data "azurerm_container_app_environment" "mcshared" {
  name                = "${local.project}-cae"
  resource_group_name = local.compute_rg
}
