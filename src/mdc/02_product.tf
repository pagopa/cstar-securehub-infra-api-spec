resource "azurerm_api_management_product" "this" {
  for_each = local.products

  resource_group_name = local.apim_rg_name
  api_management_name = local.apim_name

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
  resource_group_name = local.apim_rg_name
  api_management_name = local.apim_name

  xml_content = each.value.policy
}

resource "azurerm_api_management_product_group" "this" {
  for_each = local.product_group_assignments

  product_id          = azurerm_api_management_product.this[each.value.product_key].product_id
  group_name          = each.value.group_name
  api_management_name = local.apim_name
  resource_group_name = local.apim_rg_name
}
