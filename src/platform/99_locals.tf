locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  apim_rg_name = "cstar-${var.env_short}-api-rg"
  apim_name    = "cstar-${var.env_short}-apim"

  apim_hostname   = var.env == "prod" ? "api.platform.pagopa.it" : "api.${var.env}.platform.pagopa.it"
  shared_hostname = var.env == "prod" ? "weuprod.shared.internal.platform.pagopa.it" : "weu${var.env}.shared.internal.${var.env}.platform.pagopa.it"
}
