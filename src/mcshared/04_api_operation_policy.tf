resource "azurerm_api_management_api_operation_policy" "this" {
  for_each = local.api_operation_policy

  api_name            = azurerm_api_management_api.this[each.value.api_name].name
  api_management_name = local.apim_name
  resource_group_name = data.azurerm_api_management.apim_core.resource_group_name
  operation_id        = each.key
  xml_content         = each.value.xml_content

  depends_on = [
    azurerm_api_management_policy_fragment.this,
    azurerm_api_management_api.this
  ]
}
