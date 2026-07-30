resource "azurerm_api_management_subscription" "this" {
  for_each = {
    for k, v in local.subscription_keys : k => v
    if contains(try(local.products[v.product].env_enabled, [var.env_short]), var.env_short)
  }

  api_management_name = local.apim_name
  resource_group_name = local.apim_rg_name

  product_id   = azurerm_api_management_product.this[each.value.product].id
  display_name = each.value.display_name
  state        = each.value.state

}

data "azurerm_key_vault" "subscription_keys" {
  for_each = {
    for k, v in azurerm_api_management_subscription.this : k => local.subscription_keys[k]
    if try(local.subscription_keys[k].kv_name, null) != null && try(local.subscription_keys[k].kv_rg, null) != null
  }

  name                = each.value.kv_name
  resource_group_name = each.value.kv_rg
}

resource "azurerm_key_vault_secret" "subscription_keys" {
  for_each = {
    for k, v in azurerm_api_management_subscription.this : k => v
    if try(local.subscription_keys[k].kv_name, null) != null && try(local.subscription_keys[k].kv_rg, null) != null
  }

  name         = try(local.subscription_keys[each.key].secret_name, "${each.key}-subkey")
  value        = each.value.primary_key
  key_vault_id = data.azurerm_key_vault.subscription_keys[each.key].id

  tags = module.tag_config.tags
}
