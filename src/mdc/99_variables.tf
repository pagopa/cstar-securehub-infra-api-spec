variable "ingress_load_balancer_hostname" {
  type = string
}

variable "rate_limit_emd_product" {
  type        = number
  description = "Rate limit for MIN INT product"
}

variable "rate_limit_emd_message" {
  type        = number
  description = "Rate limit for send message"
}

variable "mdc_openid_url" {
  type        = string
  description = "OpenId MIL url"
}

variable "mdc_issuer_url" {
  type        = string
  description = " MDC issuer url"
}
