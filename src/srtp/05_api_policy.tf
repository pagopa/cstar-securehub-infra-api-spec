resource "azurerm_api_management_api_policy" "this" {
  for_each = {
    for k, api in local.apis : k => api if contains(keys(api), "api_policy")
  }

  api_name            = "${local.project}-${each.key}"
  api_management_name = local.apim_name
  resource_group_name = local.apim_rg_name

  xml_content = each.value.api_policy.xml_content

  depends_on = [
    azurerm_api_management_api.this
  ]
}
