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
    origins                     = local.origins_bonus_elettrodomestici.base
    rate_limit_merchants_portal = var.rate_limit_merchants_portal_product
  })

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
  path         = "idpay-itn/onboarding/web"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayonboardingworkflow/idpay/onboarding/web"

  content_format = "openapi"
  content_value = templatefile("./apim/api/idpay_onboarding_workflow/openapi.onboarding.yml", {
    api_channel = "WEB"
  })

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_users_product.product_id]
  subscription_required = false

  api_operation_policies = [

    {
      operation_id = "initiativeDetail"
      xml_content = templatefile("./apim/api/idpay_onboarding_workflow/get-initiative-details-policy.xml.tpl", {
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
    }
  ]

}
