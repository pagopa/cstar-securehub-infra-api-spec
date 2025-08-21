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
module "idpay_itn_register_portal_api" {
  source = "./.terraform/modules/__v4__/api_management_api"

  name                = "${var.env_short}-idpay-itn-register-operation"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  description  = "IDPAY ITN Register Portal Operation"
  display_name = "IDPAY ITN Register Portal Operation API"
  path         = "idpay-itn/register"
  protocols    = ["https"]

  service_url = "${local.domain_aks_ingress_load_balancer_https}/idpayassetregisterbackend/"

  content_format = "openapi"
  content_value  = file("./apim/api/idpay_asset_register/openapi.register.yml")

  xml_content = file("./apim/api/base_policy.xml")

  product_ids           = [module.idpay_itn_api_register_product.product_id]
  subscription_required = false

  api_operation_policies = [
    {
      operation_id = "userPermission"
      xml_content = templatefile("./apim/api/idpay_asset_register/get-permissions.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "savePortalConsent"
      xml_content = templatefile("./apim/api/idpay_asset_register/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getPortalConsent"
      xml_content = templatefile("./apim/api/idpay_asset_register/consent-policy.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "retrieveInstitutionById"
      xml_content = templatefile("./apim/api/idpay_asset_register/get-institution.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname,
        selc_base_url                  = var.selc_base_url,
        selfcare_api_key_reference     = azurerm_api_management_named_value.selfcare_api_key.display_name
      })
    },
    {
      operation_id = "downloadErrorReport"
      xml_content = templatefile("./apim/api/idpay_asset_register/get-product-files-report.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getProductFilesList"
      xml_content = templatefile("./apim/api/idpay_asset_register/get-product-files.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "uploadProductList"
      xml_content = templatefile("./apim/api/idpay_asset_register/post-product-files.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getProducts"
      xml_content = templatefile("./apim/api/idpay_asset_register/get-products.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getBatchNameList"
      xml_content = templatefile("./apim/api/idpay_asset_register/get-product-files-batch-name.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "getInstitutionsList"
      xml_content = templatefile("./apim/api/idpay_asset_register/get-institutions.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname,
        selc_base_url                  = var.selc_base_url,
        selfcare_api_key_reference     = azurerm_api_management_named_value.selfcare_api_key.display_name
      })
    },
    {
      operation_id = "verifyProductList"
      xml_content = templatefile("./apim/api/idpay_asset_register/post-product-files-verify.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname,
        selc_base_url                  = var.selc_base_url,
        selfcare_api_key_reference     = azurerm_api_management_named_value.selfcare_api_key.display_name
      })
    },
    {
      operation_id = "updateProductStatusRestored"
      xml_content = templatefile("./apim/api/idpay_asset_register/post-products-update-status-restored.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateProductStatusApproved"
      xml_content = templatefile("./apim/api/idpay_asset_register/post-products-update-status-approved.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateProductStatusWaitApproved"
      xml_content = templatefile("./apim/api/idpay_asset_register/post-products-update-status-wait_approved.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateProductStatusSupervised"
      xml_content = templatefile("./apim/api/idpay_asset_register/post-products-update-status-supervised.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    },
    {
      operation_id = "updateProductStatusRejected"
      xml_content = templatefile("./apim/api/idpay_asset_register/post-products-update-status-rejected.xml.tpl", {
        ingress_load_balancer_hostname = local.domain_aks_ingress_hostname
      })
    }
  ]
}
