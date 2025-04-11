locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  dns_zone_third = "${var.third_level_domain}.pagopa.it"

  apim_name      = "${local.project_core}-apim"
  apim_rg        = "${local.project_core}-api-rg"
  apim_logger_id = "${data.azurerm_api_management.this.id}/loggers/${local.apim_name}-logger"

  apim_hostname    = var.env_short == "p" ? "api.${local.dns_zone_third}" : "api.${var.env}.${local.dns_zone_third}"
  fe_hostname      = var.env_short == "p" ? local.dns_zone_third : "${var.env}.${local.dns_zone_third}"
  ingress_endpoint = var.env_short == "p" ? "https://${var.dns_zone_internal_entry}.${local.dns_zone_third}" : "https://${var.dns_zone_internal_entry}.${var.env}.${local.dns_zone_third}"

  # PATH API
  context_path_fesp                  = "payhub/public/fesp/landing"
  context_path_mypay_landing         = "payhub/public/landing"
  context_path_pag_tel_ccp           = "payhub/ws/fesp/PagamentiTelematiciCCP"
  context_path_pag_tel_ccp36         = "payhub/ws/fesp/PagamentiTelematiciCCP36"
  context_path_pag_tel_rt            = "payhub/ws/fesp/PagamentiTelematiciRT"
  context_path_pa_for_node           = "payhub/soap/node/wsdl/PaForNode"
  context_path_pag_tel_dp_ente       = "payhub/ws/pa/PagamentiTelematiciDovutiPagati"
  context_path_pag_tel_pagt_ric_ente = "payhubpivot/ws/pivot/PagamentiTelematiciPagatiRiconciliati"
}
