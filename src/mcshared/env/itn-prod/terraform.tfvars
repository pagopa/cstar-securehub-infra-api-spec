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
