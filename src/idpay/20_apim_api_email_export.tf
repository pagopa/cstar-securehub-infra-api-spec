#
# IDPAY PRODUCTS EXPORT
#

module "idpay_itn_api_portal_product_export" {
  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_portal_product_export"
  display_name = "IDPAY_ITN_APP_PORTAL_PRODUCT_EXPORT"
  description  = "IDPAY_ITN_APP_PORTAL_PRODUCT_EXPORT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0


  policy_xml = file("./apim/api_product/export_rdb/policy_email.xml")

}

## IDPAY Email API EXPORT ##
module "idpay_itn_notification_email_export" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-${local.prefix_api}-idpay-email-export"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Notification Email Export"
  display_name = "IDPAY ITN Notification Email API Export"
  path         = "idpay-itn/email-notification/export"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpaynotificationemail/"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_notification_email_export/openapi.notification.email.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_product_export.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "sendEmail"

      xml_content = templatefile("./apim/api/idpay_notification_email_export/post-notify-email-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

}

