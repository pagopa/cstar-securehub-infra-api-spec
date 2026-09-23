data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}
