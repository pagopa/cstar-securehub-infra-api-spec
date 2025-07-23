resource "azurerm_api_management_api_version_set" "this" {
  for_each = {
    for k, api in local.apis : k => api.version_set
    if contains(keys(api), "version_set")
  }

  name                = each.value.name
  display_name        = each.value.display_name
  api_management_name = local.apim_name
  resource_group_name = local.apim_rg_name
  versioning_scheme   = each.value.versioning_scheme
  version_header_name = lookup(each.value, "version_header_name", null)
  version_query_name  = lookup(each.value, "version_query_name", null)
}
