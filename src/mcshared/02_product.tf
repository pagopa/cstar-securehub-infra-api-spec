resource "azurerm_api_management_product" "this" {
  for_each = local.products

  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name
  api_management_name = data.azurerm_api_management.apim_core.name

  product_id            = each.key
  display_name          = each.value.display_name
  description           = each.value.description
  subscription_required = each.value.subscription_required
  published             = each.value.published
}
