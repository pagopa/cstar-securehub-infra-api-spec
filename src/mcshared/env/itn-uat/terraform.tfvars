prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "mcshared"
location_short = "itn"


mil_auth_openapi_descriptor = "https://raw.githubusercontent.com/pagopa/mil-auth/384998980f984f31d7f92022974a56da9f79f6a9/src/main/resources/META-INF/openapi_not_admin.yaml"

mil_get_access_token_allowed_origins = [
  "https://rtp.uat.cstar.pagopa.it",
  "https://welfare.uat.cstar.pagopa.it"
]

mil_get_access_token_rate_limit = {
  calls  = 100
  period = 60
}

mil_get_jwks_rate_limit = {
  calls  = 100
  period = 60
}

mil_get_open_id_conf_rate_limit = {
  calls  = 100
  period = 60
}

mil_introspect_rate_limit = {
  calls  = 10
  period = 60
}
