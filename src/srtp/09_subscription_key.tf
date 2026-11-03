resource "azurerm_api_management_subscription" "this" {
  for_each = local.subscription_keys

  api_management_name = local.apim_name
  resource_group_name = local.apim_rg_name

  api_id        = try(azurerm_api_management_api.this[each.value.api_name].id, null)
  product_id    = try(azurerm_api_management_product.this[each.value.product].id, null)
  display_name  = each.value.display_name
  state         = each.value.state
  allow_tracing = try(each.value.allow_tracing, false)
}

resource "azurerm_key_vault_secret" "subscription_keys" {
  for_each = azurerm_api_management_subscription.this

  name         = try(local.subscription_keys[each.key].secret_name, "${each.key}-subkey")
  value        = each.value.primary_key
  key_vault_id = data.azurerm_key_vault.domain_kv.id

  tags = module.tag_config.tags
}
