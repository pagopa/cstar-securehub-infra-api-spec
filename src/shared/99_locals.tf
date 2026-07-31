locals {
  product             = "${var.prefix}-${var.env_short}"
  project             = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_no_location = "${var.prefix}-${var.env_short}-${var.domain}"

  # APIM
  apim_rg_name      = "cstar-${var.env_short}-api-rg"
  apim_name         = "cstar-${var.env_short}-apim"
  apim_logger_id    = "${data.azurerm_api_management.apim.id}/loggers/${local.project}-apim-logger"
  api_management_id = data.azurerm_api_management.apim.id

  # KV
  kv_name = "${local.project}-kv"
  kv_rg   = "${local.project}-security-rg"

  dns_external_domain    = "pagopa.it"
  dns_zone               = "${var.env != "prod" ? "${var.env}." : ""}${var.prefix}.${local.dns_external_domain}"
  internal_domain_suffix = "internal"

  api_context_path = "shared"
  api_ingress_url  = "${var.domain}.${var.location_short}.${local.internal_domain_suffix}.${local.dns_zone}"
  api_service_url  = "https://${local.api_ingress_url}"

  appgw_hostname = "api-io.${local.dns_zone}"

  apis = merge({
    # RTP Activation
    mock-io = {
      env_enabled           = ["d", "u"]
      display_name          = "Shared - Mock IO TEST API"
      description           = "Shared - Mock IO API server"
      path                  = "${local.api_context_path}/mock-io"
      revision              = "1"
      protocols             = ["https"]
      service_url           = "${local.api_service_url}/cstarmockbackendio/bpd/pagopa/api/v1"
      subscription_required = true
      product               = "shared-mock"
      import_descriptor = {
        content_format = "openapi"
        content_value = templatefile("./api/mock_io/swagger.json", {
          host      = local.appgw_hostname
          base_path = "/${local.api_context_path}/mock-io"
        })
      }
    }
  })

  products = {
    # SRTP
    shared-mock = {
      env_enabled           = ["d", "u"]
      display_name          = "Shared - Mock IO API Product"
      description           = "Shared - Mock IO API Product"
      subscription_required = true
      published             = true
      group                 = true
    }
  }
  policy_fragment      = {}
  api_operation_policy = {}

  subscription_keys = {
    shared-mock-product = {
      product      = "shared-mock"
      display_name = "Shared - Mock IO API Product Subscription Key"
      state        = "active"
      kv_name      = local.kv_name
      kv_rg        = local.kv_rg
    }
  }
}
