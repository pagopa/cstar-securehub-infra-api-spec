data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}

data "azurerm_container_app_environment" "srtp" {
  name                = "${local.project}-cae"
  resource_group_name = local.compute_rg
}
