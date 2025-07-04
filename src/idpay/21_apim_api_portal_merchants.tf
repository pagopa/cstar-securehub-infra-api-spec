#
# IDPAY PRODUCTS
#

module "idpay_itn_api_portal_merchants_product" {
  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_portal_merchants_product"
  display_name = "IDPAY_ITN_APP_PORTAL_MERCHANTS_PRODUCT"
  description  = "IDPAY_ITN_APP_PORTAL_MERCHANTS_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./apim/api_product/portal_merchants_api/policy_merchants_portal.xml.tpl", {
    jwt_cert_signing_kv_id      = azurerm_api_management_certificate.idpay_merchants_token_exchange_cert_jwt.name,
    origins                     = local.origins.base
    rate_limit_merchants_portal = var.rate_limit_merchants_portal_product
  })

}

#
# IDPAY API
#

## IDPAY Welfare Portal User Permission API ##
module "idpay_itn_merchants_permission_portal" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-merchants-portal-permission"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Merchants Portal User Permission"
  display_name = "IDPAY ITN Merchants Portal User Permission API"
  path         = "idpay-itn/merchant/authorization"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayportalwelfarebackendrolepermission/idpay/welfare"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_role_permission/openapi.role-permission.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_merchants_product.product_id]
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

## IDPAY Welfare Portal Email API ##
module "idpay_itn_merchants_notification_email_api" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-${local.prefix_api}-idpay-merchants-email"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Merchants Notification Email"
  display_name = "IDPAY ITN Merchants Notification Email API"
  path         = "idpay-itn/merchant/email-notification"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpaynotificationemail/"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_notification_email/openapi.notification.email.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_merchants_product.product_id]
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

      xml_content = templatefile("./apim/api/idpay_notification_email/get-institution-user-info-merchant-policy.xml.tpl", {
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

## IDPAY Welfare Merchants Portal API ##
module "idpay_itn_merchants_portal" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-${local.prefix_api}-idpay-merchants-portal"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Merchants Portal"
  display_name = "IDPAY ITN Merchants Portal API"
  path         = "idpay-itn/merchant/portal"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpaymerchant/idpay/merchant/portal"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_merchants_portal/openapi.merchants.portal.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_merchants_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getMerchantInitiativeStatistics"

      xml_content = templatefile("./apim/api/idpay_merchants_portal/get-merchant-statistics-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "createTransaction"

      xml_content = templatefile("./apim/api/idpay_merchants_portal/post-create-merchant-transaction-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getMerchantTransactions"

      xml_content = templatefile("./apim/api/idpay_merchants_portal/get-merchant-transactions-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getMerchantTransactionsProcessed"

      xml_content = templatefile("./apim/api/idpay_merchants_portal/get-merchant-transactions-processed-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "deleteTransaction"

      xml_content = templatefile("./apim/api/idpay_merchants_portal/delete-merchant-transaction-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "authPaymentBarCode"

      xml_content = templatefile("./apim/api/idpay_merchants_portal/put-bar-code-authorize-merchant-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

  depends_on = [
    azurerm_api_management_named_value.selc_external_api_key
  ]

}
