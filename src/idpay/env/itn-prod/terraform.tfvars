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
# Rate limit
#
rate_limit_assistance_product   = 1000
rate_limit_issuer_product       = 2000
rate_limit_mil_merchant_product = 2000
rate_limit_mil_citizen_product  = 2000

rate_limit_minint_product = 1000

rate_limit_portal_product           = 2500
rate_limit_merchants_portal_product = 2500


#
# Register Token Exchange
#
invitalia_fc      = "05678721001"
selfcare_base_url = "https://api.selfcare.pagopa.it/external/v2"

#
# PDV
#
pdv_tokenizer_url      = "https://api.tokenizer.pdv.pagopa.it/tokenizer/v1"
pdv_timeout_sec        = 15
pdv_retry_count        = 3
pdv_retry_interval     = 5
pdv_retry_max_interval = 15
pdv_retry_delta        = 1

#
# AKS Legacy
#
aks_legacy_instance_name = "prod01"

#
# IO
#
appio_timeout_sec     = 5
rate_limit_io_product = 2500
webViewUrl            = "https://api-io.cstar.pagopa.it/idpay/self-expense/login"

#
# RTD
#
reverse_proxy_rtd = "127.0.0.1"

#
# Payment
#
pm_timeout_sec = 5
pm_backend_url = "https://api.platform.pagopa.it"

#
# FLAGS
#
enable_flags = {
  mock_io_api     = false
  mocked_merchant = false
}

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
