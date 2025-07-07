prefix          = "cstar"
env_short       = "d"
env             = "dev"
domain          = "mcshared"
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

# MIL
mil_auth_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-auth/384998980f984f31d7f92022974a56da9f79f6a9/src/main/resources/META-INF/openapi_not_admin.yaml"
mil_get_access_token_allowed_origins = [
  "https://rtp.dev.cstar.pagopa.it",
  "https://welfare.dev.cstar.pagopa.it"
]
