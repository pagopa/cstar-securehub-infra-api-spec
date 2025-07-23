data "azurerm_container_app_environment" "mcshared" {
  name                = "${local.project}-cae"
  resource_group_name = local.compute_rg
}
