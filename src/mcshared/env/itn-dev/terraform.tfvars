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
# AKS Legacy
#
aks_legacy_instance_name = "dev01"


