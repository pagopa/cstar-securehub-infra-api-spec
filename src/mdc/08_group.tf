resource "azurerm_api_management_group" "this" {
  for_each = {
    for k, product in local.products : k => product
    if try(product.group, false) == true
  }

  name                = var.domain
  resource_group_name = local.apim_rg_name
  api_management_name = local.apim_name
  display_name        = upper(var.domain)
}
