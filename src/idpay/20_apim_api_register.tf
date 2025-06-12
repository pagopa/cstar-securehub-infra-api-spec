#
# IDPAY PRODUCTS
#
module "idpay_itn_api_register_product" {
  source = "./.terraform/modules/__v4__/api_management_product"


  product_id   = "idpay_itn_api_register_product"
  display_name = "IDPAY_ITN_REGISTER_PRODUCT"
  description  = "IDPAY_ITN_REGISTER_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

  policy_xml = templatefile("./apim/api_product/portal_register/policy_portal.xml.tpl", {
    jwt_cert_signing_kv_id = azurerm_api_management_certificate.idpay_register_token_exchange_cert_jwt.name,
    origins                = local.origins.base
    rate_limit_portal      = var.rate_limit_portal_product
  })

}

#
# IDPAY API
#

module "idpay_itn_permission_register" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-register-permission"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Register Portal Permission"
  display_name = "IDPAY ITN Register Portal Permission API"
  path         = "idpay-itn/register/authorization"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayassetregisterbackend/idpay/welfare"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_asset_register/role-permission/openapi.role-permission.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_register_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "userPermission"
      xml_content = templatefile("./apim/api/idpay_asset_register/role-permission/get-permission-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "savePortalConsent"
      xml_content = templatefile("./apim/api/idpay_asset_register/role-permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getPortalConsent"
      xml_content = templatefile("./apim/api/idpay_asset_register/role-permission/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]

}
