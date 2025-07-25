#
# IDPAY PRODUCTS
#

module "idpay_api_mock_product" {
  source = "./.terraform/modules/__v4__/api_management_product"
  count  = var.enable_flags.mock_io_api ? 1 : 0


  product_id   = "idpay_itn_api_mock_product"
  display_name = "IDPAY_ITN_MOCK_PRODUCT"
  description  = "IDPAY_ITN_MOCK_PRODUCT"

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  published             = false
  subscription_required = false
  approval_required     = false

  subscriptions_limit = 0

}

## IDPAY Mock API ##
resource "azurerm_api_management_api" "idpay_mock_api" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  name                = "${var.env_short}-idpay-int-mock-api"
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name

  revision              = "1"
  description           = "IDPAY ITN MOCK API"
  display_name          = "IDPAY ITN MOCK API"
  path                  = "idpay-itn/mock"
  protocols             = ["https"]
  subscription_required = false

  depends_on = [module.idpay_api_mock_product]
}

resource "azurerm_api_management_product_api" "idpay_mock_product_api" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  product_id          = module.idpay_api_mock_product[0].product_id
  depends_on          = [module.idpay_api_mock_product, azurerm_api_management_api.idpay_mock_api]
}


## IDPAY Mock Operations ##
## IDPAY Mock Notificator (messages) ##
resource "azurerm_api_management_api_operation" "idpay_mock_notificator_messages" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_notificator_messages"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock notificator messages"
  method              = "POST"
  url_template        = "/api/v1/messages"
  description         = "Endpoint for mock notificator messages api"
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_notificator_messages_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_notificator_messages[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_notificator_messages[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_notificator_messages[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_notificator_messages[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_notificator_messages.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_notificator_messages[0]]

}

## IDPAY Mock Notificator (profiles) ##
resource "azurerm_api_management_api_operation" "idpay_mock_notificator_profiles" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_notificator_profiles"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock notificator profiles"
  method              = "POST"
  url_template        = "/api/v1/profiles"
  description         = "Endpoint for mock notificator profiles api"
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_notificator_profiles_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_notificator_profiles[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_notificator_profiles[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_notificator_profiles[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_notificator_profiles[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_notificator_profiles.xml.tpl", {
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_notificator_profiles[0]]

}

## IDPAY MOCK BE IO - create service ##
resource "azurerm_api_management_api_operation" "idpay_mock_create_service" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_create_service"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO create services"
  method              = "POST"
  url_template        = "/api/v1/manage/services"
  description         = "Endpoint for mock BE IO create services api"
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_create_service_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_create_service[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_create_service[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_create_service[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_create_service[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_create_service.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_create_service[0]]

}

## IDPAY MOCK BE IO - delete service ##
resource "azurerm_api_management_api_operation" "idpay_mock_delete_service" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_delete_service"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO delete services"
  method              = "DELETE"
  url_template        = "/api/v1/manage/services/{serviceId}"
  description         = "Endpoint for mock BE IO delete services api"
  template_parameter {
    name     = "serviceId"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_delete_service_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_delete_service[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_delete_service[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_delete_service[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_delete_service[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_delete_service.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_delete_service[0]]

}

## IDPAY MOCK BE IO - update service ##
resource "azurerm_api_management_api_operation" "idpay_mock_update_service" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_update_service"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO update services"
  method              = "PUT"
  url_template        = "/api/v1/manage/services/{serviceId}"
  description         = "Endpoint for mock BE IO update services api"
  template_parameter {
    name     = "serviceId"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_update_service_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_update_service[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_update_service[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_update_service[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_update_service[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_update_service.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_update_service[0]]

}

## IDPAY MOCK BE IO - upload service logo ##
resource "azurerm_api_management_api_operation" "idpay_mock_upload_service_logo" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_upload_service_logo"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO upload services logo"
  method              = "PUT"
  url_template        = "/api/v1/manage/services/{serviceId}/logo"
  description         = "Endpoint for mock BE IO upload service logo"
  template_parameter {
    name     = "serviceId"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_upload_service_logo_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_upload_service_logo[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_upload_service_logo[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_upload_service_logo[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_upload_service_logo[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_upload_service_logo.xml.tpl", {
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_upload_service_logo[0]]

}

## IDPAY MOCK BE IO - retrieve service token ##
resource "azurerm_api_management_api_operation" "idpay_mock_retrieve_service_token" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_retrieve_service_token"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock BE IO retrieve service token"
  method              = "GET"
  url_template        = "/api/v1/manage/services/{serviceId}/keys"
  description         = "Endpoint for mock BE IO retrieve service token api"
  template_parameter {
    name     = "serviceId"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_retrieve_service_token_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_retrieve_service_token[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_retrieve_service_token[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_retrieve_service_token[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_retrieve_service_token[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_retrieve_service_token.xml.tpl", {
    env = var.env
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_retrieve_service_token[0]]

}

## IDPAY ONE TRUST ##
resource "azurerm_api_management_api_operation" "idpay_mock_tos_version" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  operation_id        = "idpay_mock_tos_version"
  api_name            = azurerm_api_management_api.idpay_mock_api[0].name
  api_management_name = data.azurerm_api_management.apim_core.name
  resource_group_name = data.azurerm_resource_group.apim_rg.name
  display_name        = "IDPAY Mock TOS Version"
  method              = "GET"
  url_template        = "/api/privacynotice/v2/privacynotices/{id}"
  description         = "Endpoint for mock One Trust privacy version"
  template_parameter {
    name     = "id"
    type     = "string"
    required = true
  }
}

resource "azurerm_api_management_api_operation_policy" "idpay_mock_tos_version_policy" {
  count = var.enable_flags.mock_io_api ? 1 : 0

  api_name            = azurerm_api_management_api_operation.idpay_mock_tos_version[0].api_name
  api_management_name = azurerm_api_management_api_operation.idpay_mock_tos_version[0].api_management_name
  resource_group_name = azurerm_api_management_api_operation.idpay_mock_tos_version[0].resource_group_name
  operation_id        = azurerm_api_management_api_operation.idpay_mock_tos_version[0].operation_id

  xml_content = templatefile("./apim/api/idpay_mock_api/mock_tos_version.xml.tpl", {
  })

  depends_on = [azurerm_api_management_api_operation.idpay_mock_tos_version[0]]

}
