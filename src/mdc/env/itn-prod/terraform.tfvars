prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "mdc"
location_short = "itn"

ingress_load_balancer_hostname = "REPLACE_WITH_PROD_INGRESS_HOST"
rate_limit_emd_product         = 60
rate_limit_emd_message         = 60
mdc_openid_url                 = "https://replace-with-openid.prod/.well-known/openid-configuration"
mdc_issuer_url                 = "https://replace-with-issuer.prod"
