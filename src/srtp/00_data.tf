data "azurerm_api_management" "apim" {
  name                = local.apim_name
  resource_group_name = local.apim_rg_name
}

data "azurerm_key_vault" "domain_kv" {
  name                = local.domain_kv_name
  resource_group_name = local.domain_kv_rg_name
}

data "azurerm_storage_account" "share_storage" {
  name                = local.rtp_share_storage_account_name
  resource_group_name = local.data_rg_name
}
