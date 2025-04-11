# general
prefix         = "p4pa"
env_short      = "p"
env            = "prod"
domain         = "payhub"
location       = "italynorth"
location_short = "itn"


tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "P4PA"
  Source      = "https://github.com/pagopa/p4pa-infra-api-spec"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

third_level_domain      = "p4pa"
dns_zone_internal_entry = "hub.internal"

apim_diagnostics_enabled = true
