locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  #
  # Network
  #
  dns_public_core_name          = "${var.dns_zone_prefix}.${var.external_domain}"
  vnet_core_resource_group_name = "${local.product}-vnet-rg"

  #
  # APIM
  #
  apim_rg_name      = "cstar-${var.env_short}-api-rg"
  apim_name         = "cstar-${var.env_short}-apim"
  apim_logger_id    = "${data.azurerm_api_management.apim_core.id}/loggers/${local.apim_name}-logger"
  api_management_id = data.azurerm_api_management.apim_core.id

  # Default Domain Resource Group
  compute_rg = "${local.project}-compute-rg"

  # 🔎 DNS
  dns_external_domain = "pagopa.it"
  dns_zone_internal   = "internal.${var.env != "prod" ? "${var.env}." : ""}${var.prefix}.${local.dns_external_domain}"
}

locals {
  apis = {
    # MIL ITN
    mil-auth = {
      display_name          = "MIL ITN Auth API"
      description           = "Authorization Microservice"
      path                  = "mil-auth-itn"
      revision              = "1"
      protocols             = ["https"]
      service_url           = "https://${local.project}-auth-ca.${data.azurerm_container_app_environment.mcshared.default_domain}"
      subscription_required = false
      product               = "mcshared-itn"
      import_descriptor = {
        content_format = "openapi-link"
        content_value  = var.mil_auth_openapi_descriptor
      }
    }
    # Keycloak ITN
    auth = {
      display_name          = "McShared Keycloak Auth ITN"
      description           = "Authorization Microservice - Keycloak"
      path                  = "auth-itn"
      revision              = "1"
      protocols             = ["https"]
      service_url           = "https://keycloak.itn.${local.dns_zone_internal}"
      subscription_required = false
      product               = "mcshared-itn"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./apim/api/oidc/openapi.yaml")
      }
      api_policy = {
        xml_content = templatefile("./apim/api/base_policy.xml", {})
      }
      api_diagnostic = {
        name              = "applicationinsights"
        always_log_errors = true
        verbosity         = "information"
      }
    }
  }

  products = {
    # MCSHARED ITN
    mcshared-itn = {
      display_name          = "McShared ITN"
      description           = "Shared Multi Channel Services"
      subscription_required = false
      published             = true
    }
  }

  policy_fragment = {
    rate-limit-by-clientid-claim-v2 = {
      description = "Rate limit by client id value received as claim of the access token"
      format      = "rawxml"
      value       = templatefile("policies/fragments/rate-limit-by-clientid-claim.xml", {})
    }
    rate-limit-by-clientid-formparam-v2 = {
      description = "Rate limit by client id value received as form param"
      format      = "rawxml"
      value       = templatefile("policies/fragments/rate-limit-by-clientid-formparam.xml", {})
    }
  }

  api_operation_policy = {
    getOpenIdConf = {
      api_name = "mil-auth"
      xml_content = templatefile("policies/rate-limit-and-cache.xml", {
        calls  = var.mil_get_open_id_conf_rate_limit.calls
        period = var.mil_get_open_id_conf_rate_limit.period
      })
    }
    introspect = {
      api_name = "mil-auth"
      xml_content = templatefile("policies/introspect.xml", {
        calls       = var.mil_introspect_rate_limit.calls
        period      = var.mil_introspect_rate_limit.period
        fragment_id = "rate-limit-by-clientid-claim-v2"
      })
    }
    getJwks = {
      api_name = "mil-auth"
      xml_content = templatefile("policies/rate-limit-and-cache.xml", {
        calls  = var.mil_get_jwks_rate_limit.calls
        period = var.mil_get_jwks_rate_limit.period
      })
    }
    getAccessTokens = {
      api_name = "mil-auth"
      xml_content = templatefile("policies/getAccessToken.xml", {
        calls           = var.mil_get_access_token_rate_limit.calls
        period          = var.mil_get_access_token_rate_limit.period
        fragment_id     = "rate-limit-by-clientid-formparam-v2"
        allowed_origins = join("", formatlist("<origin>%s</origin>", var.mil_get_access_token_allowed_origins))
      })
    }
  }
}
