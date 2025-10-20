resource "azurerm_api_management_policy_fragment" "apim-validate-token-mdc" {
  name              = "emd-validate-token-mdc"
  api_management_id = data.azurerm_api_management.apim_core.id

  description = "emd-validate-token-mdc"
  format      = "rawxml"
  value = templatefile("./api_fragment/validate-token-mdc.xml", {
    openidUrl = var.mdc_openid_url,
    issuerUrl = var.mdc_issuer_url
  })
}
