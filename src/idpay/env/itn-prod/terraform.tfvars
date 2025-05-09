prefix          = "cstar"
env_short       = "p"
env             = "prod"
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
dns_zone_prefix          = "cstar"
dns_zone_internal_prefix = "internal.cstar"
external_domain          = "pagopa.it"

#
# AKS Legacy
#
aks_legacy_instance_name = "prod01"


webViewUrl = "https://api-io.cstar.pagopa.it/idpay/self-expense/login"

#
# Payment
#
pm_backend_url = "https://api.platform.pagopa.it"

#
# Mocked
#
idpay_mocked_acquirer_apim_user_id = null

#
# MIL
#
#TODO: TO CHANGE
openid_config_url_mil = "https://mil-u-apim.azure-api.net/mil-auth/.well-known/openid-configuration"
mil_openid_url        = "https://api-mcshared.cstar.pagopa.it/auth/.well-known/openid-configuration"
mil_issuer_url        = "https://api-mcshared.cstar.pagopa.it/auth"

#
# SelfCare API
#
selc_base_url    = "https://api.selfcare.pagopa.it"
selc_timeout_sec = 5
