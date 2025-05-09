prefix          = "cstar"
env_short       = "u"
env             = "uat"
domain          = "idpay"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra-api-spec"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Dns
#
dns_zone_prefix          = "uat.cstar"
dns_zone_internal_prefix = "internal.uat.cstar"
external_domain          = "pagopa.it"

#
# AKS Legacy
#
aks_legacy_instance_name = "uat01"


webViewUrl = "https://api-io.uat.cstar.pagopa.it/idpay/self-expense/login"

#
# Payment
#
pm_backend_url      = "https://api.uat.platform.pagopa.it"

#
# Mocked
#
idpay_mocked_acquirer_apim_user_id = "rtd-uat-acquirer-pagopa-it"

#
# MIL
#
openid_config_url_mil = "https://mil-u-apim.azure-api.net/mil-auth/.well-known/openid-configuration"
mil_openid_url        = "https://api-mcshared.uat.cstar.pagopa.it/auth/.well-known/openid-configuration"
mil_issuer_url        = "https://api-mcshared.uat.cstar.pagopa.it/auth"

#
# SelfCare API
#
selc_base_url = "https://api.uat.selfcare.pagopa.it"
selc_timeout_sec = 5
