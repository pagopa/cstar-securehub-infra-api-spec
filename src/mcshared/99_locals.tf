locals {
  product    = "${var.prefix}-${var.env_short}"
  project    = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  #
  # Network
  #
  vnet_core_name                = "${local.product}-vnet"
  dns_public_core_name          = "${var.dns_zone_prefix}.${var.external_domain}"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  #
  # AKS
  #
  domain_aks_ingress_hostname            = "${var.domain}.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"
  domain_aks_ingress_load_balancer_https = "https://${local.domain_aks_ingress_hostname}"

  #
  # APIM
  #
  apim_rg_name   = "cstar-${var.env_short}-api-rg"
  apim_name      = "cstar-${var.env_short}-apim"
  apim_logger_id = "${data.azurerm_api_management.apim_core.id}/loggers/${local.apim_name}-logger"

}
