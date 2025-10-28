locals {
  product             = "${var.prefix}-${var.env_short}"
  project             = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_no_location = "${var.prefix}-${var.env_short}-${var.domain}"

  apim_rg_name      = "cstar-${var.env_short}-api-rg"
  apim_name         = "cstar-${var.env_short}-apim"
  apim_logger_id    = "${data.azurerm_api_management.apim.id}/loggers/${local.project}-apim-logger"
  api_management_id = data.azurerm_api_management.apim.id

  ingress_load_balancer_https = "https://${var.ingress_load_balancer_hostname}"

  products = {
    emd_api_product = {
      display_name          = "EMD_PRODUCT"
      description           = "EMD_PRODUCT"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/policy_emd.xml", {
        rate_limit_emd = var.rate_limit_emd_message
      })
      groups = ["developers"]
      group  = true
    }
    emd_mdc_api_product = {
      display_name          = "EMD_MDC_PRODUCT"
      description           = "EMD_MDC_PRODUCT"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/mdc/policy_mdc.xml", {
        rate_limit_emd = var.rate_limit_emd_product
      })
      groups = ["developers"]
    }
    emd_tpp_product = {
      display_name          = "EMD_TPP_PRODUCT"
      description           = "EMD_TPP_PRODUCT"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/tpp/policy_emd.xml", {
        rate_limit_emd = var.rate_limit_emd_product
      })
      groups = ["developers"]
    }
    emd_retrieval_api_product = {
      display_name          = "EMD_RETRIEVAL_PRODUCT"
      description           = "EMD_RETRIEVAL_PRODUCT"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/retrieval/policy_emd.xml", {
        rate_limit_emd = var.rate_limit_emd_product
      })
      groups = ["developers"]
    }
  }

  product_group_assignments = {
    for assignment in flatten([
      for product_key, product in local.products : [
        for group_name in lookup(product, "groups", []) : {
          id          = "${product_key}-${group_name}"
          product_key = product_key
          group_name  = group_name
        }
      ]
    ]) : assignment.id => assignment
  }

  apis = {
    emd_tpp = {
      name                  = "${var.env_short}-emd-tpp"
      description           = "EMD TPP"
      display_name          = "EMD TPP API"
      path                  = "emd/tpp"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      product               = "emd_tpp_product"
      service_url           = "${local.ingress_load_balancer_https}/emdtpp/emd/tpp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_tpp/openapi.tpp.yml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
    emd_citizen = {
      name                  = "${var.env_short}-emd-citizen"
      description           = "EMD CITIZEN CONSENT"
      display_name          = "EMD CITIZEN CONSENT API"
      path                  = "emd/citizen"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      product               = "emd_api_product"
      service_url           = "${local.ingress_load_balancer_https}/emdcitizen/emd/citizen"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_citizen/openapi.citizen.yml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
    emd_message_core = {
      name                  = "${var.env_short}-emd-message-core"
      description           = "EMD MESSAGE CORE"
      display_name          = "EMD MESSAGE CORE API"
      path                  = "emd/message-core"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      product               = "emd_api_product"
      service_url           = "${local.ingress_load_balancer_https}/emdmessagecore/emd/message-core"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_message_core/openapi.emd.yml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
    emd_payment_core = {
      name                  = "${var.env_short}-emd_payment_core"
      description           = "EMD PAYMENT CORE"
      display_name          = "EMD PAYMENT CORE API"
      path                  = "emd/payment"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      product               = "emd_retrieval_api_product"
      service_url           = "${local.ingress_load_balancer_https}/emdpaymentcore/emd/payment"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_payment_core/openapi.payment.yaml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
    emd_mdc_citizen = {
      name                  = "${var.env_short}-emd-mdc-citizen"
      description           = "EMD CITIZEN OPERATION"
      display_name          = "EMD CITIZEN OPERATION API"
      path                  = "emd/mdc/citizen"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      product               = "emd_mdc_api_product"
      service_url           = "${local.ingress_load_balancer_https}/emdcitizen/emd/citizen"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_mdc_citizen/openapi.mdc.citizen.yml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
    emd_mdc_tpp_testing = {
      name                  = "${var.env_short}-emd-mdc-tpp-testing"
      description           = "EMD TPP NETWORK TESTING"
      display_name          = "EMD TPP NETWORK TESTING API"
      path                  = "emd/mdc/tpp"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      product               = "emd_mdc_api_product"
      service_url           = "${local.ingress_load_balancer_https}/emdtpp/emd/tpp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_mdc_testing/openapi.mdc.tpp.yml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
  }

  policy_fragment = {
    "emd-validate-token-mdc" = {
      description = "emd-validate-token-mdc"
      format      = "rawxml"
      value = templatefile("./api_fragment/validate-token-mdc.xml", {
        openidUrl = var.mdc_openid_url
        issuerUrl = var.mdc_issuer_url
      })
    }
  }

  api_operation_policy = {
    emd_tpp_save = {
      api_name     = "emd_tpp"
      operation_id = "save"
      xml_content = templatefile("./api/emd_tpp/post-save-tpp-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_tpp_updateTppDetails = {
      api_name     = "emd_tpp"
      operation_id = "updateTppDetails"
      xml_content = templatefile("./api/emd_tpp/put-update-tpp-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_tpp_updateTokenSection = {
      api_name     = "emd_tpp"
      operation_id = "updateTokenSection"
      xml_content = templatefile("./api/emd_tpp/put-update-token-section-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_tpp_updateState = {
      api_name     = "emd_tpp"
      operation_id = "updateState"
      xml_content = templatefile("./api/emd_tpp/put-update-tpp-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_tpp_getTppDetails = {
      api_name     = "emd_tpp"
      operation_id = "getTppDetails"
      xml_content = templatefile("./api/emd_tpp/get-tpp-detail.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_tpp_getTokenSection = {
      api_name     = "emd_tpp"
      operation_id = "getTokenSection"
      xml_content = templatefile("./api/emd_tpp/get-token-section.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_tpp_getNetworkConnection = {
      api_name     = "emd_tpp"
      operation_id = "getNetworkConnection"
      xml_content = templatefile("./api/emd_tpp/get-network-connection.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_citizen_saveCitizenConsent = {
      api_name     = "emd_citizen"
      operation_id = "saveCitizenConsent"
      xml_content = templatefile("./api/emd_citizen/post-insert-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_citizen_stateSwitch = {
      api_name     = "emd_citizen"
      operation_id = "stateSwitch"
      xml_content = templatefile("./api/emd_citizen/put-update-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_citizen_getCitizenConsentStatus = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenConsentStatus"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_citizen_getCitizenConsentsList = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenConsentsList"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_citizen_getCitizenConsentsListEnabled = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenConsentsListEnabled"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-enabled-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_citizen_getCitizenEnabled = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenEnabled"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-enabled-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_message_core_submitMessage = {
      api_name     = "emd_message_core"
      operation_id = "submitMessage"
      xml_content = templatefile("./api/emd_message_core/post-send-courtesy-message-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_payment_core_retrievalTokens = {
      api_name     = "emd_payment_core"
      operation_id = "retrievalTokens"
      xml_content = templatefile("./api/emd_payment_core/post-save-retrieval-payload.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_payment_core_getRetrieval = {
      api_name     = "emd_payment_core"
      operation_id = "getRetrieval"
      xml_content = templatefile("./api/emd_payment_core/get-retrieval-payload.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_payment_core_generateDeepLink = {
      api_name     = "emd_payment_core"
      operation_id = "generateDeepLink"
      xml_content = templatefile("./api/emd_payment_core/generate-deeplink.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_mdc_citizen_saveCitizenConsent = {
      api_name     = "emd_mdc_citizen"
      operation_id = "saveCitizenConsent"
      xml_content = templatefile("./api/emd_mdc_citizen/post-insert-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_mdc_citizen_stateSwitch = {
      api_name     = "emd_mdc_citizen"
      operation_id = "stateSwitch"
      xml_content = templatefile("./api/emd_mdc_citizen/put-update-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_mdc_citizen_getCitizenConsentStatus = {
      api_name     = "emd_mdc_citizen"
      operation_id = "getCitizenConsentStatus"
      xml_content = templatefile("./api/emd_mdc_citizen/get-citizen-consent-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_mdc_citizen_getCitizenEnabled = {
      api_name     = "emd_mdc_citizen"
      operation_id = "getCitizenEnabled"
      xml_content = templatefile("./api/emd_mdc_citizen/get-citizen-consent-enabled-policy.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
    emd_mdc_tpp_testing_getNetworkConnection = {
      api_name     = "emd_mdc_tpp_testing"
      operation_id = "getNetworkConnection"
      xml_content = templatefile("./api/emd_mdc_testing/get-network-connection.xml.tpl", {
        ingress_load_balancer_hostname = var.ingress_load_balancer_hostname
      })
    }
  }
}
