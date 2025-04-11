data "azurerm_api_management" "this" {
  name                = local.apim_name
  resource_group_name = local.apim_rg
}