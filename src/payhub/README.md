## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | <= 2.51.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 3.107.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.107.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | 81c34fb63bbd2c8b275ac43df21863c344f85df2 |
| <a name="module_apim_api_auth"></a> [apim\_api\_auth](#module\_apim\_api\_auth) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_mypay"></a> [apim\_api\_mypay](#module\_apim\_api\_mypay) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_mypay_landing"></a> [apim\_api\_mypay\_landing](#module\_apim\_api\_mypay\_landing) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_mypay_sil"></a> [apim\_api\_mypay\_sil](#module\_apim\_api\_mypay\_sil) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_mypivot"></a> [apim\_api\_mypivot](#module\_apim\_api\_mypivot) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_mypivot_sil"></a> [apim\_api\_mypivot\_sil](#module\_apim\_api\_mypivot\_sil) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_pagamenti_telematici_CCP"></a> [apim\_api\_pagamenti\_telematici\_CCP](#module\_apim\_api\_pagamenti\_telematici\_CCP) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_pagamenti_telematici_CCP36"></a> [apim\_api\_pagamenti\_telematici\_CCP36](#module\_apim\_api\_pagamenti\_telematici\_CCP36) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_pagamenti_telematici_RT"></a> [apim\_api\_pagamenti\_telematici\_RT](#module\_apim\_api\_pagamenti\_telematici\_RT) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_pagamenti_telematici_dovuti_pagati_ente"></a> [apim\_api\_pagamenti\_telematici\_dovuti\_pagati\_ente](#module\_apim\_api\_pagamenti\_telematici\_dovuti\_pagati\_ente) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_api_pagamenti_telematici_pagati_riconciliati_ente"></a> [apim\_api\_pagamenti\_telematici\_pagati\_riconciliati\_ente](#module\_apim\_api\_pagamenti\_telematici\_pagati\_riconciliati\_ente) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_payhub_product"></a> [apim\_payhub\_product](#module\_apim\_payhub\_product) | ./.terraform/modules/__v3__/api_management_product | n/a |
| <a name="module_apim_pu_bff"></a> [apim\_pu\_bff](#module\_apim\_pu\_bff) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_pu_fileshare"></a> [apim\_pu\_fileshare](#module\_apim\_pu\_fileshare) | ./.terraform/modules/__v3__/api_management_api | n/a |
| <a name="module_apim_well_known"></a> [apim\_well\_known](#module\_apim\_well\_known) | ./.terraform/modules/__v3__/api_management_api | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api_diagnostic.apim_api_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_group.payhub_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_group) | resource |
| [azurerm_api_management.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apim_diagnostics_enabled"></a> [apim\_diagnostics\_enabled](#input\_apim\_diagnostics\_enabled) | To enable or not APIm diagnostics data | `bool` | n/a | yes |
| <a name="input_dns_zone_internal_entry"></a> [dns\_zone\_internal\_entry](#input\_dns\_zone\_internal\_entry) | The internal dns entry | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_third_level_domain"></a> [third\_level\_domain](#input\_third\_level\_domain) | Third level domain XXX.pagopa.it | `string` | n/a | yes |

## Outputs

No outputs.
