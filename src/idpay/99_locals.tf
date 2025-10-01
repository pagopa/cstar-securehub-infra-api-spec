locals {
  product    = "${var.prefix}-${var.env_short}"
  project    = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  prefix_api = "idpay-itn"
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
  # KV
  #
  domain_kv_name    = "${local.project}-kv"
  domain_kv_rg_name = "${local.project}-security-rg"

  #
  # APIM
  #
  apim_rg_name   = "cstar-${var.env_short}-api-rg"
  apim_name      = "cstar-${var.env_short}-apim"
  apim_logger_id = "${data.azurerm_api_management.apim_core.id}/loggers/${local.project}-apim-logger"

  #
  # Data
  #
  data_resource_group_name = "${local.project}-data-rg"
  initiative_storage_name  = "cstar${var.env_short}itnidpayinitatvsa"
  initiative_storage_fqdn  = data.azurerm_storage_account.initiative_storage.primary_blob_internet_endpoint

  refund_storage_fqdn = data.azurerm_storage_account.refund_storage.primary_blob_internet_endpoint
  refund_storage_name = "cstar${var.env_short}itnidpayrefundsa"

  #
  # ORIGINS (used for CORS on IDPAY Welfare Portal)
  #
  origins = {
    base = concat(
      [
        "https://portal.${data.azurerm_dns_zone.public.name}",
        "https://management.${data.azurerm_dns_zone.public.name}",
        "https://${local.apim_name}.developer.azure-api.net",
        "https://${local.idpay-register-hostname}",
        "https://${local.idpay-portal-welfare}"
      ],
      var.env_short != "p" ? ["https://localhost:3000", "http://localhost:3000", "https://localhost:3001", "http://localhost:3001"] : []
    )
  }

  #
  # ORIGINS (used for CORS on User and Merchant OP Portals)
  #
  origins_bonus_elettrodomestici = {
    base = concat(
      local.bonus_el_env_dns_public_zones,
      var.env_short != "p" ? ["https://localhost:3000", "http://localhost:3000", "https://localhost:3001", "http://localhost:3001", "https://localhost:5173", "http://localhost:5173"] : []
    )
  }

  #
  # Selfcare
  #
  idpay-register-hostname = "eie.${data.azurerm_dns_zone.public.name}"
  idpay-portal-welfare    = "welfare.${data.azurerm_dns_zone.public.name}"
  idpay-oidc-config_url   = "https://welfare.${data.azurerm_dns_zone.public.name}/selfcare/openid-configuration.json"
  selfcare-issuer         = "https://${var.env != "prod" ? "${var.env}." : ""}selfcare.pagopa.it"

  # monitor_appinsights_name        = "${local.product}-appinsights"
  # monitor_action_group_slack_name = "SlackPagoPA"
  # monitor_action_group_email_name = "PagoPA"
  # alert_action_group_domain_name  = "${var.prefix}${var.env_short}${var.domain}"
  #
  # # ingress_hostname_prefix               = "${var.instance}.${var.domain}"
  # internal_dns_zone_name                = "${var.dns_zone_internal_prefix}.${var.external_domain}"
  # internal_dns_zone_resource_group_name = "${local.product}-vnet-rg"
  #
  # apim_rg_name = "cstar-${var.env_short}-api-rg"
  # apim_name    = "cstar-${var.env_short}-apim"
  # # apim_logger_id                = "${data.azurerm_api_management.apim_core.id}/loggers/${local.apim_name}-logger"

  #
  # #ORIGINS (used for CORS on IDPAY Welfare Portal)
  # origins = {
  #   base = concat(
  #     [
  #       # "https://portal.${data.azurerm_dns_zone.public.name}",
  #       # "https://management.${data.azurerm_dns_zone.public.name}",
  #       # "https://${local.apim_name}.developer.azure-api.net",
  #       # "https://${local.idpay-portal-hostname}",
  #     ],
  #     var.env_short != "p" ? ["https://localhost:3000", "http://localhost:3000", "https://localhost:3001", "http://localhost:3001"] : []
  #   )
  # }
  #
  # idpay_eventhubs = {
  #   evh01 = {
  #     namespace           = "${local.product}-${var.domain}-evh-ns-01"
  #     resource_group_name = "${local.product}-${var.domain}-msg-rg"
  #   }
  #   evh00 = {
  #     namespace           = "${local.product}-${var.domain}-evh-ns-00"
  #     resource_group_name = "${local.product}-${var.domain}-msg-rg"
  #   }
  # }

  # domain_aks_hostname                      = var.env == "prod" ? "${var.instance}.${var.domain}.internal.cstar.pagopa.it" : "${var.instance}.${var.domain}.internal.${var.env}.cstar.pagopa.it"
  rtd_domain_aks_hostname                  = var.env == "prod" ? "${var.aks_legacy_instance_name}.rtd.internal.cstar.pagopa.it" : "${var.aks_legacy_instance_name}.rtd.internal.${var.env}.cstar.pagopa.it"
  rtd_ingress_load_balancer_hostname_https = "https://${local.rtd_domain_aks_hostname}"
  # initiative_storage_fqdn                  = "${module.idpay_initiative_storage.name}.blob.core.windows.net"
  # reward_storage_fqdn                      = "${module.idpay_refund_storage.name}.blob.core.windows.net"
  #

  # 🔎 DNS - Bonus Elettrodomestici
  bonus_el_dns_public_zones = [
    "bonuselettrodomestici.it",
    "bonuselettrodomestici.com",
    "bonuselettrodomestici.info",
    "bonuselettrodomestici.io",
    "bonuselettrodomestici.net",
    "bonuselettrodomestici.eu",
    "bonuselettrodomestici.pagopa.it"
  ]

  bonus_el_env_dns_public_zones = [
    for i in local.bonus_el_dns_public_zones :
    var.env_short != "p" ? "https://${var.env}.${i}" : "https://${i}"
  ]

  # OpenId configuration for Merchant Op
  openid_config_url_merchant_op = "${var.keycloak_url_merchant_op}/.well-known/openid-configuration"
  merchant_op_client_id         = "frontend"

  # AWS places
  aws_places_endpoint = "places.geo.eu-central-1.amazonaws.com"

  # OpenId configuration for User
  openid_config_url_user    = "${var.keycloak_url_user}/.well-known/openid-configuration"
  user_client_id            = "frontend"
  keycloak_url_user_account = "${var.keycloak_url_user}/account"

  mcshared-datavault-url = "https://${local.domain_aks_ingress_hostname}/mcshareddatavault"
}
