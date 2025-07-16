resource "azurerm_api_management_api" "this" {
  for_each = local.apis

  name                  = "${local.project}-${each.key}"
  resource_group_name   = data.azurerm_api_management.apim.resource_group_name
  api_management_name   = data.azurerm_api_management.apim.name
  revision              = each.value.revision
  display_name          = each.value.display_name
  description           = each.value.description
  path                  = each.value.path
  protocols             = each.value.protocols
  service_url           = lookup(each.value, "service_url", null)
  subscription_required = each.value.subscription_required
  version               = lookup(each.value, "version", null)
  version_set_id        = try(azurerm_api_management_api_version_set.this[each.key].id, null)

  dynamic "import" {
    for_each = try([each.value.import_descriptor], [])
    content {
      content_format = import.value.content_format
      content_value  = import.value.content_value
    }
  }
  depends_on = [
    azurerm_api_management_api_version_set.this
  ]
}

resource "azurerm_api_management_product_api" "this" {
  for_each = local.apis

  product_id          = azurerm_api_management_product.this[each.value.product].product_id
  api_name            = azurerm_api_management_api.this[each.key].name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_api_management.apim.resource_group_name
}
