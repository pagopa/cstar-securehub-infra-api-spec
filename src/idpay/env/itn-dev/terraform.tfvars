prefix          = "cstar"
env_short       = "d"
env             = "dev"
domain          = "idpay"
location        = "italynorth"
location_string = "Italy North"
location_short  = "itn"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Dev"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra-api-spec"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# Dns
#
dns_zone_prefix          = "dev.cstar"
dns_zone_internal_prefix = "internal.dev.cstar"
external_domain          = "pagopa.it"

#
# Rate limit
#
rate_limit_assistance_product = 1000
         rate_limit_issuer_product = 2000
rate_limit_mil_merchant_product = 2000
rate_limit_mil_citizen_product = 2000



#
# PDV
#
pdv_tokenizer_url = "127.0.0.1"
pdv_timeout_sec = 15
   pdv_retry_count = 3
        pdv_retry_interval = 5
         pdv_retry_max_interval = 15
             pdv_retry_delta = 1

#
# AKS Legacy
#
aks_legacy_instance_name = "dev01"

#
# IO
#
appio_timeout_sec = 5
rate_limit_io_product = 2500
webViewUrl = "https://api-io.dev.cstar.pagopa.it/idpay/self-expense/login"

#
# RTD
#
reverse_proxy_rtd = "127.0.0.1"

#
# Payment
#
payment_timeout_sec = 5
pm_backend_url      = "https://api.dev.platform.pagopa.it"
