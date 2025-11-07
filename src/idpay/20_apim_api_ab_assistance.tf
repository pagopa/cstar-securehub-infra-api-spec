#
# IDPAY APPLIANCE BONUS (BONUS ELETTRODOMESTICI) ASSISTANCE API
#
module "idpay_itn_api_ab_assistance_product" {
  source = "./.terraform/modules/__v4__/api_management_product"

  product_id   = "idpay_itn_api_ab_assistance_product"
  display_name = "IDPAY_ITN_APP_AB_ASSISTANCE_PRODUCT"
  description  = "IDPAY_ITN_APP_AB_ASSISTANCE_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = true

  subscriptions_limit = 50
}

module "idpay_itn_ab_assistance_api" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-ab-assistance"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN AB ASSISTANCE"
  display_name = "IDPAY ITN AB ASSISTANCE API"
  path         = "idpay-itn/ab/assistance"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayportalwelfarebackeninitiative/"

  content_format = "openapi"
  content_value  = templatefile("./apim/api/idpay-ab-assistance/openapi.assistance.yml", {})

  xml_content = file("./apim/api/base_policy.xml")


  product_ids = [module.idpay_itn_api_ab_assistance_product.product_id]

  api_operation_policies = [
    {
      operation_id = "getOnboardingStatus"
      xml_content = templatefile("./apim/api/idpay-ab-assistance/get-onboarding-status.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getVoucherStatus"
      xml_content = templatefile("./apim/api/idpay-ab-assistance/get-voucher-status.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]
}
