locals {
  product             = "${var.prefix}-${var.env_short}"
  project             = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_no_location = "${var.prefix}-${var.env_short}-${var.domain}"

  # APIM
  apim_rg_name      = "cstar-${var.env_short}-api-rg"
  apim_name         = "cstar-${var.env_short}-apim"
  apim_logger_id    = "${data.azurerm_api_management.apim.id}/loggers/${local.project}-apim-logger"
  api_management_id = data.azurerm_api_management.apim.id

  dns_external_domain = "pagopa.it"
  dns_zone            = "${var.env != "prod" ? "${var.env}." : ""}${var.prefix}.${local.dns_external_domain}"
  rtp_fe_origin       = "rtp.${local.dns_zone}"

  # Default Domain Resource Group
  compute_rg = "${local.project}-compute-rg"

  # RTP Storage Account
  rtp_storage_account_name = "cstar${var.env_short}${var.location_short}srtpsa"

  # MC Shared URL
  mc_shared_base_url = "https://api-mcshared.${local.dns_zone}/auth"
  api_context_path   = "rtp"

  apis = {
    # RTP Activation
    rtp-activation = {
      display_name          = "RTP ITN Activation API"
      description           = "RTP ITN Activation API"
      path                  = "${local.api_context_path}/activation"
      revision              = "1"
      version               = "v1"
      protocols             = ["https"]
      service_url           = "https://${local.project_no_location}-activator-ca.${data.azurerm_container_app_environment.srtp.default_domain}"
      subscription_required = false
      product               = "srtp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = templatefile("./api/pagopa/activation.yaml", {})
      }
      version_set = {
        name                = "${var.env_short}-rtp-activation-api-v2"
        display_name        = "RTP ITN Activation API"
        versioning_scheme   = "Header"
        version_header_name = "Version"
      }
      api_policy = {
        xml_content = templatefile("./api/pagopa/activation_base_policy.xml", {
          fragment_id = "rtp-validate-token-mcshared-v2"
        })
      }
      api_diagnostic = {
        name                      = "applicationinsights"
        sampling_percentage       = 100.0
        always_log_errors         = true
        log_client_ip             = true
        verbosity                 = "information"
        http_correlation_protocol = "W3C"
        headers_to_log            = ["RequestId"]
      }
    }
    # RTP Mock
    rtp-mock = {
      description           = "RTP ITN MOCK API EPC"
      display_name          = "RTP ITN MOCK API EPC"
      path                  = "${local.api_context_path}/mock"
      revision              = "1"
      protocols             = ["https"]
      subscription_required = false
      product               = "srtp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = templatefile("./api/epc/EPC133-22_v3.1_SRTP_spec.openapi.yaml", {})
      }
    }
    # RTP Payees Registry
    rtp-payees-registry = {
      description           = "RTP ITN Payees Registry API"
      display_name          = "RTP ITN Payees Registry API"
      path                  = "${local.api_context_path}/payees"
      revision              = "1"
      version               = "v1"
      protocols             = ["https"]
      subscription_required = false
      product               = "srtp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = templatefile("./api/pagopa/payees_registry.yaml", {})
      }
      version_set = {
        name                = "${var.env_short}-rtp-payees-registry-v2"
        display_name        = "RTP Payees Registry API"
        versioning_scheme   = "Header"
        version_header_name = "Version"
      }
      api_policy = {
        xml_content = templatefile("./api/pagopa/payees_registry_base_policy.xml", {
          fragment_id = "rtp-validate-blob-storage-payees-token-mcshared-v2"
        })
      }
      api_diagnostic = {
        name                      = "applicationinsights"
        sampling_percentage       = 100.0
        always_log_errors         = true
        log_client_ip             = true
        verbosity                 = "information"
        http_correlation_protocol = "W3C"
        headers_to_log            = ["RequestId"]
      }
    }
    # RTP CALLBACK
    rtp-callback = {
      description           = "RTP ITN CALLBACK API"
      display_name          = "RTP ITN CALLBACK API"
      path                  = "${local.api_context_path}/cb"
      revision              = "1"
      protocols             = ["https"]
      service_url           = "https://${local.project_no_location}-sender-ca.${data.azurerm_container_app_environment.srtp.default_domain}"
      subscription_required = false
      product               = "srtp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = templatefile("./api/epc/callback.openapi.yaml", {})
      }
    }
    # RTP Service Provider
    rtp-service-provider = {
      description           = "RTP ITN Service Provider API"
      display_name          = "RTP ITN Service Provider API"
      path                  = local.api_context_path
      revision              = "1"
      version               = "v1"
      protocols             = ["https"]
      service_url           = "https://${local.project_no_location}-sender-ca.${data.azurerm_container_app_environment.srtp.default_domain}"
      subscription_required = false
      product               = "srtp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = templatefile("./api/pagopa/send.openapi.yaml", {})
      }
      version_set = {
        name                = "${var.env_short}-rtp-service-provider-v2"
        display_name        = "RTP ITN Service Provider API"
        versioning_scheme   = "Header"
        version_header_name = "Version"
      }
    }
    # RTP Service Providers Registry
    rtp-service_providers-registry = {
      description           = "RTP ITN Service Providers Registry API"
      display_name          = "RTP ITN Service Providers Registry API"
      path                  = "${local.api_context_path}/service_providers"
      revision              = "1"
      version               = "v1"
      protocols             = ["https"]
      subscription_required = false
      product               = "srtp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = templatefile("./api/pagopa/service_providers_registry.yaml", {})
      }
      version_set = {
        name                = "${var.env_short}-rtp-service_providers-registry-api-v2"
        display_name        = "RTP ITN Service Providers Registry API"
        versioning_scheme   = "Header"
        version_header_name = "Version"
      }
      api_policy = {
        xml_content = templatefile("./api/pagopa/service_providers_registry_base_policy.xml", {
          fragment_id = "rtp-validate-blob-storage-service-providers-token-mcshared-v2"
        })
      }
      api_diagnostic = {
        name                      = "applicationinsights"
        sampling_percentage       = 100.0
        always_log_errors         = true
        log_client_ip             = true
        verbosity                 = "information"
        http_correlation_protocol = "W3C"
        headers_to_log            = ["RequestId"]
      }
    }
  }
  products = {
    # SRTP
    srtp = {
      display_name          = "RTP ITN Request To Pay"
      description           = "RTP Request To Pay"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/base_policy.xml", {
        rtp_fe_origin = local.rtp_fe_origin,
        dev_origin    = var.env_short != "d" ? "" : "\n<origin>http://localhost:1234</origin>"
      })
      group = true
    }
  }

  policy_fragment = {
    rtp-validate-token-mcshared-v2 = {
      description = "rtp-validate-token-mcshared"
      format      = "xml"
      value = templatefile("./api_fragment/validate-token-mcshared.xml", {
        mc_shared_base_url = local.mc_shared_base_url
      })
    }
    rtp-validate-blob-storage-payees-token-mcshared-v2 = {
      description = "rtp-validate-blob-storage-payees-token-mcshared"
      format      = "xml"
      value = templatefile("./api_fragment/validate-token-payees-mcshared_blob_storage.xml", {
        mc_shared_base_url = local.mc_shared_base_url
        rtp_group_name     = "read_rtp_payees",
      })
    }
    rtp-validate-blob-storage-service-providers-token-mcshared-v2 = {
      description = "rtp-validate-blob-storage-service-providers-token-mcshared"
      format      = "xml"
      value = templatefile("./api_fragment/validate-token-service-providers-mcshared_blob_storage.xml", {
        mc_shared_base_url = local.mc_shared_base_url,
        rtp_group_name     = "read_service_registry"
      })
    },
    registry-access-logger = {
      description = "registry-access-logger"
      format      = "xml"
      value = templatefile("./api_fragment/registry-access-logger.xml", {
        mc_shared_base_url = local.mc_shared_base_url,
        apim_logger_name   = "${local.project}-apim-logger"
      })
    }
  }

  api_operation_policy = {
    activate = {
      api_name    = "rtp-activation"
      xml_content = templatefile("./api/pagopa/activation_policy.xml", {})
    }
    postRequestToPayRequests = {
      api_name    = "rtp-mock"
      xml_content = file("./api/test/mock_policy_epc.xml")
    }
    postRequestToPayCancellationRequest = {
      api_name    = "rtp-mock"
      xml_content = file("./api/test/mock_policy_epc.xml")
    }
    getPayees = {
      api_name = "rtp-payees-registry"
      xml_content = templatefile("./api/pagopa/payees_registry_get_policy.xml", {
        storage_account_name = local.rtp_storage_account_name
      })
    }
    createRtp = {
      api_name = "rtp-service-provider"
      xml_content = templatefile("./api/pagopa/send_policy.xml", {
        fragment_id = "rtp-validate-token-mcshared-v2",
        enableAuth  = var.enable_auth_send
      })
    }
    getServiceProviders = {
      api_name = "rtp-service_providers-registry"
      xml_content = templatefile("./api/pagopa/service_providers_registry_get_policy.xml", {
        storage_account_name = local.rtp_storage_account_name
      })
    }
  }
}
