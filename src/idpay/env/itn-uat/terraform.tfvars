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
dns_zone_prefix      = "uat.cstar"
dns_zone_internal_prefix = "internal.uat.cstar"
external_domain          = "pagopa.it"
