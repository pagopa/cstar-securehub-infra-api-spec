# ------------------------------------------------------------------------------
# Policy fragments.
# ------------------------------------------------------------------------------
resource "azurerm_api_management_policy_fragment" "this" {
  for_each = local.policy_fragment

  name              = each.key
  description       = each.value.description
  api_management_id = local.api_management_id
  format            = each.value.format
  value             = each.value.value
}
