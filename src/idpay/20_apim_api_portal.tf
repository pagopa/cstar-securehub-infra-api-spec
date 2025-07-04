#
# IDPAY PRODUCTS
#

module "idpay_itn_api_portal_product" {
  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_portal_product"
  display_name = "IDPAY_ITN_APP_PORTAL_PRODUCT"
  description  = "IDPAY_ITN_APP_PORTAL_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./apim/api_product/portal_api/policy_portal.xml.tpl", {
    jwt_cert_signing_kv_id = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.name,
    origins                = local.origins.base
    rate_limit_portal      = var.rate_limit_portal_product
  })

}

#
# IDPAY API
#

## IDPAY Welfare Portal User Permission API ##
module "idpay_itn_permission_portal" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-portal-permission"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Welfare Portal User Permission"
  display_name = "IDPAY ITN Welfare Portal User Permission API"
  path         = "idpay-itn/authorization"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayportalwelfarebackendrolepermission/idpay/welfare"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_role_permission/openapi.role-permission.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "userPermission"
      xml_content = templatefile("./apim/api/idpay_role_permission/get-permission-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "savePortalConsent"
      xml_content = templatefile("./apim/api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getPortalConsent"
      xml_content = templatefile("./apim/api/idpay_role_permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

}

## IDPAY Welfare Portal Initiative API ##
module "idpay_itn_initiative_portal" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-initiative"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Welfare Portal Initiative"
  display_name = "IDPAY ITN Welfare Portal Initiative API"
  path         = "idpay-itn/initiative"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayportalwelfarebackeninitiative/idpay/initiative"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_initiative/openapi.initiative.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getListOfOrganization"

      xml_content = templatefile("./apim/api/idpay_initiative/get-organization-list.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getInitativeSummary"

      xml_content = templatefile("./apim/api/idpay_initiative/get-initiative-summary.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getInitiativeDetail"

      xml_content = templatefile("./apim/api/idpay_initiative/get-initiative-detail.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "saveInitiativeServiceInfo"

      xml_content = templatefile("./apim/api/idpay_initiative/post-initiative-info.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeServiceInfo"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-info.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeGeneralInfo"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-general.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeGeneralInfoDraft"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-general-draft.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeBeneficiary"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-beneficiary.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeBeneficiaryDraft"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-beneficiary-draft.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateTrxAndRewardRules"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-reward.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateTrxAndRewardRulesDraft"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-reward-draft.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeRefundRule"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-refund.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeRefundRuleDraft"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-refund-draft.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeApprovedStatus"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-approve.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativeToCheckStatus"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-reject.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInitiativePublishedStatus"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-publish.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "logicallyDeleteInitiative"

      xml_content = templatefile("./apim/api/idpay_initiative/delete-initiative-general.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "suspendUserRefund"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-suspension-refund.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "readmitUserRefund"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-readmission-refund.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "suspendUserDiscount"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-suspension-discount.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "readmitUserDiscount"

      xml_content = templatefile("./apim/api/idpay_initiative/put-initiative-readmission-discount.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    //CONFIG
    {
      operation_id = "getBeneficiaryConfigRules"

      xml_content = templatefile("./apim/api/idpay_initiative/simple-mock-policy.xml", {})
    },
    {
      operation_id = "getTransactionConfigRules"

      xml_content = templatefile("./apim/api/idpay_initiative/get-config-transaction-rule.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getMccConfig"

      xml_content = templatefile("./apim/api/idpay_initiative/get-config-mcc.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "initiativeStatistics"

      xml_content = templatefile("./apim/api/idpay_initiative/get-initiative-statistics.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getRewardNotificationExportsPaged"

      xml_content = templatefile("./apim/api/idpay_initiative/get-initiative-reward-notifications-exp.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getRewardNotificationImportsPaged"

      xml_content = templatefile("./apim/api/idpay_initiative/get-initiative-reward-notifications-imp.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getOnboardingStatus"

      xml_content = templatefile("./apim/api/idpay_initiative/get-onboarding-status.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getInitiativeOnboardingRankingStatusPaged"

      xml_content = templatefile("./apim/api/idpay_initiative/get-ranking.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getRankingFileDownload"

      xml_content = templatefile("./apim/api/idpay_initiative/get-ranking-download.xml.tpl", {
        initiative-storage-account-fqdn-private = local.initiative_storage_fqdn
      })
    },
    {
      operation_id = "notifyCitizenRankings"

      xml_content = templatefile("./apim/api/idpay_initiative/put-ranking-notify.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getRewardFileDownload"

      xml_content = templatefile("./apim/api/idpay_initiative/get-reward-download.xml.tpl", {
        refund-storage-account-fqdn-private = local.refund_storage_fqdn
      })
    },
    {
      operation_id = "putDispFileUpload"

      xml_content = templatefile("./apim/api/idpay_initiative/put-disp-upload.xml.tpl", {
        refund-storage-account-name = local.refund_storage_name
      })
    },
    {
      operation_id = "uploadAndUpdateLogo"

      xml_content = templatefile("./apim/api/idpay_initiative/put-logo-upload.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getDispFileErrors"

      xml_content = templatefile("./apim/api/idpay_initiative/get-disp-errors.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    //BENEFICIARY DETAIL
    {
      operation_id = "getIban"

      xml_content = templatefile("./apim/api/idpay_initiative/get-beneficiary-iban.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getTimeline"

      xml_content = templatefile("./apim/api/idpay_initiative/get-beneficiary-timeline.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getTimelineDetail"

      xml_content = templatefile("./apim/api/idpay_initiative/get-beneficiary-timeline-detail.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getWalletDetail"

      xml_content = templatefile("./apim/api/idpay_initiative/get-beneficiary-wallet.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getBeneficiaryOnboardingStatus"

      xml_content = templatefile("./apim/api/idpay_initiative/get-beneficiary-onboarding-status.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getFamilyComposition"

      xml_content = templatefile("./apim/api/idpay_initiative/get-beneficiary-onboarding-family-status.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getInstrumentList"

      xml_content = templatefile("./apim/api/idpay_initiative/get-beneficiary-instruments.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    //REFUND DETAIL
    {
      operation_id = "getExportSummary"

      xml_content = templatefile("./apim/api/idpay_initiative/get-refund-export-summary.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getExportRefundsListPaged"

      xml_content = templatefile("./apim/api/idpay_initiative/get-refund-list.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getRefundDetail"

      xml_content = templatefile("./apim/api/idpay_initiative/get-refund-detail.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
        pdv_timeout_sec                = var.pdv_timeout_sec
        pdv_tokenizer_url              = var.pdv_tokenizer_url
        pdv_retry_count                = var.pdv_retry_count
        pdv_retry_interval             = var.pdv_retry_interval
        pdv_retry_max_interval         = var.pdv_retry_max_interval
        pdv_retry_delta                = var.pdv_retry_delta
      })
    },
    //PORTAL TOKEN
    {
      operation_id = "getPagoPaAdminToken"

      xml_content = templatefile("./apim/api/idpay_initiative/idpay_portal_token/jwt_idpay_portal_token.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname,
        jwt_cert_signing_thumbprint    = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.thumbprint
      })
    }
  ]

}

/*
##API used for generate IdPay Product Token test
resource "azurerm_api_management_api_operation" "idpay_portal_token" {
  operation_id        = "idpay_portal_token"
  api_name            = module.idpay_initiative_portal.name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Token"
  method              = "POST"
  url_template        = "/token"
  description         = "Endpoint which create IdPay token"
}
resource "azurerm_api_management_api_operation_policy" "idpay_portal_token_policy" {
  api_name            = azurerm_api_management_api_operation.idpay_portal_token.api_name
  api_management_name = azurerm_api_management_api_operation.idpay_portal_token.api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_portal_token.resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_portal_token.operation_id

  xml_content = templatefile("./apim/api/idpay_initiative/idpay_portal_token/jwt_idpay_portal_token.xml.tpl", {
    ingress_load_balancer_hostname = local.domain_aks_ingress_hostname,
    jwt_cert_signing_thumbprint    = azurerm_api_management_certificate.idpay_token_exchange_cert_jwt.thumbprint
  })
}
*/

## IDPAY Welfare Portal Group API ##
module "idpay_itn_group_portal" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-group"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Welfare Portal File Group"
  display_name = "IDPAY ITN Welfare Portal File Group API"
  path         = "idpay-itn/group"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpaygroup/"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_group/openapi.group.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getGroupOfBeneficiaryStatusAndDetails"

      xml_content = templatefile("./apim/api/idpay_group/get-group-status.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "uploadGroupOfBeneficiary"

      xml_content = templatefile("./apim/api/idpay_group/put-group-upload.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

}

## IDPAY Merchant API ##
module "idpay_itn_merchant_portal" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-merchant"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Merchant"
  display_name = "IDPAY ITN Merchant API"
  path         = "idpay-itn/merchant"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpaymerchant/"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_merchant/openapi.merchant.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getMerchantList"

      xml_content = templatefile("./apim/api/idpay_merchant/get-merchant-list-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getMerchantDetail"

      xml_content = templatefile("./apim/api/idpay_merchant/get-merchant-detail-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "uploadMerchantList"

      xml_content = templatefile("./apim/api/idpay_merchant/put-merchant-upload.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getMerchantInitiativeStatistics"

      xml_content = templatefile("./apim/api/idpay_merchant/get-merchant-statistics-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getMerchantTransactions"

      xml_content = templatefile("./apim/api/idpay_merchant/get-merchant-transactions-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getMerchantTransactionsProcessed"

      xml_content = templatefile("./apim/api/idpay_merchant/get-merchant-transactions-processed-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

}

## IDPAY Welfare Portal Email API ##
module "idpay_itn_notification_email_api" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-${local.prefix_api}-idpay-email"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Notification Email"
  display_name = "IDPAY ITN Notification Email API"
  path         = "idpay-itn/email-notification"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpaynotificationemail/"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_notification_email/openapi.notification.email.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "sendEmail"

      xml_content = templatefile("./apim/api/idpay_notification_email/post-notify-email-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getInstitutionProductUserInfo"

      xml_content = templatefile("./apim/api/idpay_notification_email/get-institution-user-info-policy.xml.tpl", {
        ingress_load_balancer_hostname  = local.domain_aks_ingress_hostname,
        selc_base_url                   = var.selc_base_url,
        selc_timeout_sec                = var.selc_timeout_sec
        selc_external_api_key_reference = azurerm_api_management_named_value.selc_external_api_key.display_name
      })
    }
  ]

  depends_on = [
    azurerm_api_management_named_value.selc_external_api_key
  ]

}

#
# Named values
#

# # selfcare api
resource "azurerm_api_management_named_value" "selc_external_api_key" {

  name                = "${var.env_short}-${local.prefix_api}-selc-external-api-key-secret"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "${var.env_short}-${local.prefix_api}-selc-external-api-key"
  secret       = true
  value_from_key_vault {
    secret_id = data.azurerm_key_vault_secret.selc-external-api-key.versionless_id
  }
}


resource "azurerm_api_management_named_value" "refund_storage_access_key" {

  name                = "${var.env_short}-refund-storage-access-key"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "refund-storage-access-key"
  secret       = true
  value        = data.azurerm_storage_account.refund_storage.primary_access_key
}

resource "azurerm_api_management_named_value" "initiative_storage_access_key" {

  name                = "${var.env_short}-initiative-storage-access-key"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  display_name = "initiative-storage-access-key"
  secret       = true
  value        = data.azurerm_storage_account.initiative_storage.primary_access_key
}
