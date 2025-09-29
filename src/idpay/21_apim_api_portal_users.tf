#
# IDPAY PRODUCTS
#

module "idpay_itn_api_portal_users_product" {
  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_portal_users_product"
  display_name = "IDPAY_ITN_APP_PORTAL_USERS_PRODUCT"
  description  = "IDPAY_ITN_APP_PORTAL_USERS_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./apim/api_product/portal_users_api/policy_users_portal.xml.tpl", {
    origins                   = local.origins_bonus_elettrodomestici.base
    rate_limit_users_portal   = var.rate_limit_users_portal_product
    openid_config_url_user    = local.openid_config_url_user
    user_client_id            = local.user_client_id
    keycloak_url_user         = var.keycloak_url_user
    keycloak_url_user_account = local.keycloak_url_user_account
    keycloak_timeout_sec      = var.keycloak_timeout_sec
    env_short                 = var.env_short
  })

  groups = ["developers"]

  depends_on = [
    azurerm_api_management_named_value.pdv_api_key
  ]

}

#
# IDPAY USERS PORTAL
#

## IDPAY Onboarding WEB API ##
module "idpay_itn_users_portal_api" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-user-portal"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Users Portal"
  display_name = "IDPAY ITN Users Portal"
  path         = "idpay-itn/web"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayonboardingworkflow/idpay/onboarding/web"

  content_format = "openapi"
  content_value = templatefile("./apim/api/idpay_appio_full/openapi.appio.full.yml", {
    api_channel = "WEB"
  })

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_users_product.product_id]
  subscription_required = false

  api_operation_policies = [

    {
      operation_id = "initiativeDetail"
      xml_content = templatefile("./apim/api/idpay_onboarding_workflow/get-initiative-details-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "onboardingStatus"
      xml_content = templatefile("./apim/api/idpay_onboarding_workflow/get-onboarding-status-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "saveOnboarding"
      xml_content = templatefile("./apim/api/idpay_onboarding_workflow/put-save-onboarding-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getWalletDetail"
      xml_content = templatefile("./apim/api/idpay_wallet/get-wallet-detail-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getTimeline"
      xml_content = templatefile("./apim/api/idpay_timeline/get-timeline-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getTimelineDetail"
      xml_content = templatefile("./apim/api/idpay_timeline/get-timeline-detail-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "retrievectiveBarCodeTransaction"
      xml_content = templatefile("./apim/api/idpay_payment_io/get-active-barcode-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getTransactionPdf"
      xml_content = templatefile("./apim/api/idpay_payment_io/get-generate-pdf-barcode-web-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

}
