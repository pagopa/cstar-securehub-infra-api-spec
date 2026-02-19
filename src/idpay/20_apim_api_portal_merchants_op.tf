#
# IDPAY PRODUCTS
#

module "idpay_itn_api_portal_merchants_op_product" {
  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_portal_merchants_op_product"
  display_name = "IDPAY_ITN_APP_PORTAL_MERCHANTS_OP_PRODUCT"
  description  = "IDPAY_ITN_APP_PORTAL_MERCHANTS_OP_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./apim/api_product/portal_merchants_op_api/policy_merchants_op_portal.xml.tpl", {
    origins                       = local.origins_bonus_elettrodomestici.base
    rate_limit_merchants_portal   = var.rate_limit_merchants_portal_product
    openid_config_url_merchant_op = local.openid_config_url_merchant_op
    merchant_op_client_id         = local.merchant_op_client_id
    merchant_op_client_id_test    = local.merchant_op_client_id_test
    keycloak_url_merchant_op      = var.keycloak_url_merchant_op
  })

}

#
# IDPAY API
#

## IDPAY Portal Merchant Operative API ##
module "idpay_itn_portal_merchants_op_api" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-portal-merchant-op"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Portal Merchants OP API"
  display_name = "IDPAY ITN Portal Merchants OP API"
  path         = "idpay-itn/merchant-op"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpaymerchant/idpay/merchant/portal"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_merchants_op_portal/openapi.merchants.op.portal.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_portal_merchants_op_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "getProducts"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/get-rbd-products-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "capturePayment"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/put-capture-payment-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "previewPayment"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/put-payment-bar-code-preview-trxcode-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "authPaymentBarCode"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/put-bar-code-authorize-merchant-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getPointOfSaleTransactionsProcessed"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/get-pos-transactions-processed-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getPointOfSaleTransactions"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/get-pos-transactions-progress-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "deleteTransaction"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/delete-transactions-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "invoiceTransaction"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/post-invoice-payment-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "reversalTransaction"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/post-reversal-payment-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "downloadInvoiceFile"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/get-invoice-download-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getTransactionPreviewPdf"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/get-preview-pdf-payment-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateInvoiceTransaction"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/put-invoice-update-transactions-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "reversalTransactionInvoiced"
      xml_content = templatefile("./apim/api/idpay_merchants_op_portal/post-reversal-invoiced-payment-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }

  ]
}
