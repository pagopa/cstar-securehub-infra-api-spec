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

resource "azurerm_api_management_product_policy" "this" {
  for_each = {
    for k, product in local.products : k => product if contains(keys(product), "policy")
  }

  product_id          = azurerm_api_management_product.this[each.key].product_id
  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name
  api_management_name = data.azurerm_api_management.apim_core.name

  xml_content = each.value.policy
}

