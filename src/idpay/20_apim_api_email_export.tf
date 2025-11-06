############################################################
# APIM - IDPAY Email Export (Product + API + Subscription)
module "idpay_itn_api_portal_product_export" {
  source = "./.terraform/modules/__v4__/api_management_product"

  product_id   = "idpay-email-export-v2"
  display_name = "IDPAY ITN Email Export v2"
  description  = "IDPAY ITN Email Export"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = true
  subscription_required = true
  approval_required     = false

  policy_xml = file("./apim/api_product/export_rdb/policy_email.xml")

}

########################
# API (import from OpenAPI)
########################
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

  product_ids = [module.idpay_itn_api_portal_product_export.product_id]

  subscription_required = true

  api_operation_policies = [
    {
      operation_id = "sendEmail"

      xml_content = templatefile("./apim/api/idpay_notification_email_export/post-notify-email-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

  # Assicura ordine: prima il Product
  depends_on = [module.idpay_itn_api_portal_product_export]
}

############################################
# Subscription per ADF + Secret in Key Vault
############################################
resource "azurerm_api_management_subscription" "idpay_email_export_adf" {
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  api_management_name = data.azurerm_api_management.apim_core.name

  display_name = "ADF Email Export"

  product_id = module.idpay_itn_api_portal_product_export.id

  state = "active"

  depends_on = [module.idpay_itn_api_portal_product_export]
}

resource "azurerm_key_vault_secret" "apim_idpay_email_export_subkey" {
  name         = "apim-idpay-email-export-subkey"
  value        = azurerm_api_management_subscription.idpay_email_export_adf.primary_key
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id

  depends_on = [azurerm_api_management_subscription.idpay_email_export_adf]
}
