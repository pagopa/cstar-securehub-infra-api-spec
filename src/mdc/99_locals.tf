locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"

  apim_rg_name      = "cstar-${var.env_short}-api-rg"
  apim_name         = "cstar-${var.env_short}-apim"
  apim_logger_id    = "${data.azurerm_api_management.apim.id}/loggers/${local.project}-apim-logger"
  api_management_id = data.azurerm_api_management.apim.id

  ingress_load_balancer_https = "https://${var.domain}.${var.location_short}.internal${var.env == "prod" ? "" : ".${var.env}"}.${var.prefix}.pagopa.it"

  products = {
    emd_api_send_product = {
      display_name          = "EMD-SEND-PRODUCT"
      description           = "EMD Product for message sending and citizen consent management"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/policy_send.xml", {
        rate_limit_emd = var.rate_limit_emd_message
      })
      groups = ["developers"]
      group  = true
    }
    emd_api_tpp_product = {
      display_name          = "EMD-TPP-PRODUCT"
      description           = "EMD Product dedicated to Third Party Providers (TPP) integration"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/policy_tpp.xml", {
        rate_limit_emd = var.rate_limit_emd_product
      })
      groups = ["developers"]
    }
    emd_api_pagopa_product = {
      display_name          = "EMD-PAGOPA-PRODUCT"
      description           = "EMD Product for PagoPA internal services and institutional operations"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/policy_pagopa.xml", {
        rate_limit_emd = var.rate_limit_emd_product
      })
      groups = ["developers"]
    }
    emd_api_retrieval_product = {
      display_name          = "EMD-RETRIEVAL-PRODUCT"
      description           = "EMD Product for message/payment retrieval and deep-link generation"
      subscription_required = false
      published             = true
      policy = templatefile("./api_product/emd/policy_retrieval.xml", {
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
      products              = ["emd_api_pagopa_product"]
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
      description           = "EMD CITIZEN INTERNAL (for PPA)"
      display_name          = "EMD CITIZEN INTERNAL (for PPA) API"
      path                  = "emd/citizen"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      products              = ["emd_api_pagopa_product"]
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
      products              = ["emd_api_send_product"]
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
      name                  = "${var.env_short}-emd-payment-core"
      description           = "EMD PAYMENT CORE"
      display_name          = "EMD PAYMENT CORE API"
      path                  = "emd/payment"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      products              = ["emd_api_retrieval_product"]
      service_url           = "${local.ingress_load_balancer_https}/emdpaymentcore/emd/payment"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_payment_core/openapi.payment.yaml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
    emd_citizen_for_tpp = {
      name                  = "${var.env_short}-emd-citizen-for-tpp"
      description           = "EMD CITIZEN OP. FOR TPP"
      display_name          = "EMD CITIZEN OP. FOR TPP API"
      path                  = "emd/mil/citizen"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      products              = ["emd_api_tpp_product"]
      service_url           = "${local.ingress_load_balancer_https}/emdcitizen/emd/citizen"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_citizen_for_tpp/openapi.mdc.citizen.yml")
      }
      api_policy = {
        xml_content = file("./api/base_policy.xml")
      }
    }
    emd_tpp_testing = {
      name                  = "${var.env_short}-emd-tpp-testing"
      description           = "EMD TPP NETWORK TESTING"
      display_name          = "EMD TPP NETWORK TESTING API"
      path                  = "emd/mil/tpp"
      protocols             = ["https"]
      revision              = "1"
      subscription_required = false
      products              = ["emd_api_tpp_product"]
      service_url           = "${local.ingress_load_balancer_https}/emdtpp/emd/tpp"
      import_descriptor = {
        content_format = "openapi"
        content_value  = file("./api/emd_tpp_testing/openapi.mdc.tpp.yml")
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
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_tpp_updateTppDetails = {
      api_name     = "emd_tpp"
      operation_id = "updateTppDetails"
      xml_content = templatefile("./api/emd_tpp/put-update-tpp-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_tpp_updateTokenSection = {
      api_name     = "emd_tpp"
      operation_id = "updateTokenSection"
      xml_content = templatefile("./api/emd_tpp/put-update-token-section-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_tpp_updateState = {
      api_name     = "emd_tpp"
      operation_id = "updateState"
      xml_content = templatefile("./api/emd_tpp/put-update-tpp-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_tpp_getTppDetails = {
      api_name     = "emd_tpp"
      operation_id = "getTppDetails"
      xml_content = templatefile("./api/emd_tpp/get-tpp-detail.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_tpp_getTokenSection = {
      api_name     = "emd_tpp"
      operation_id = "getTokenSection"
      xml_content = templatefile("./api/emd_tpp/get-token-section.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_tpp_getNetworkConnection = {
      api_name     = "emd_tpp"
      operation_id = "getNetworkConnection"
      xml_content = templatefile("./api/emd_tpp/get-network-connection.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_saveCitizenConsent = {
      api_name     = "emd_citizen"
      operation_id = "saveCitizenConsent"
      xml_content = templatefile("./api/emd_citizen/post-insert-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_stateSwitch = {
      api_name     = "emd_citizen"
      operation_id = "stateSwitch"
      xml_content = templatefile("./api/emd_citizen/put-update-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_getCitizenConsentStatus = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenConsentStatus"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_getCitizenConsentsList = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenConsentsList"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_getCitizenConsentsListEnabled = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenConsentsListEnabled"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-enabled-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_getCitizenEnabled = {
      api_name     = "emd_citizen"
      operation_id = "getCitizenEnabled"
      xml_content = templatefile("./api/emd_citizen/get-citizen-consent-enabled-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_message_core_submitMessage = {
      api_name     = "emd_message_core"
      operation_id = "submitMessage"
      xml_content = templatefile("./api/emd_message_core/post-send-courtesy-message-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_payment_core_retrievalTokens = {
      api_name     = "emd_payment_core"
      operation_id = "retrievalTokens"
      xml_content = templatefile("./api/emd_payment_core/post-save-retrieval-payload.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_payment_core_getRetrieval = {
      api_name     = "emd_payment_core"
      operation_id = "getRetrieval"
      xml_content = templatefile("./api/emd_payment_core/get-retrieval-payload.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_payment_core_generateDeepLink = {
      api_name     = "emd_payment_core"
      operation_id = "generateDeepLink"
      xml_content = templatefile("./api/emd_payment_core/generate-deeplink.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_for_tpp_saveCitizenConsent = {
      api_name     = "emd_citizen_for_tpp"
      operation_id = "saveCitizenConsent"
      xml_content = templatefile("./api/emd_citizen_for_tpp/post-insert-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_for_tpp_stateSwitch = {
      api_name     = "emd_citizen_for_tpp"
      operation_id = "stateSwitch"
      xml_content = templatefile("./api/emd_citizen_for_tpp/put-update-citizen-consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_for_tpp_getCitizenConsentStatus = {
      api_name     = "emd_citizen_for_tpp"
      operation_id = "getCitizenConsentStatus"
      xml_content = templatefile("./api/emd_citizen_for_tpp/get-citizen-consent-status-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_citizen_for_tpp_getCitizenEnabled = {
      api_name     = "emd_citizen_for_tpp"
      operation_id = "getCitizenEnabled"
      xml_content = templatefile("./api/emd_citizen_for_tpp/get-citizen-consent-enabled-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
    emd_tpp_testing_getNetworkConnection = {
      api_name     = "emd_tpp_testing"
      operation_id = "getNetworkConnection"
      xml_content = templatefile("./api/emd_tpp_testing/get-network-connection.xml.tpl", {
        ingress_load_balancer_hostname = local.ingress_load_balancer_https
      })
    }
  }
}
