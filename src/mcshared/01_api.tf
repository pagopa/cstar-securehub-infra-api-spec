resource "azurerm_api_management_api" "this" {
  for_each = local.apis

  name                  = "${local.project}-${each.key}"
  resource_group_name   = data.azurerm_api_management.apim_core.resource_group_name
  api_management_name   = data.azurerm_api_management.apim_core.name
  revision              = each.value.revision
  display_name          = each.value.display_name
  description           = each.value.description
  path                  = each.value.path
  protocols             = each.value.protocols
  service_url           = each.value.service_url
  subscription_required = each.value.subscription_required

  dynamic "import" {
    for_each = try([each.value.import_descriptor], [])
    content {
      content_format = import.value.content_format
      content_value  = import.value.content_value
    }
  }
}

resource "azurerm_api_management_product_api" "this" {
  for_each = local.apis

  product_id          = azurerm_api_management_product.this[each.value.product].product_id
  api_name            = azurerm_api_management_api.this[each.key].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name
}
