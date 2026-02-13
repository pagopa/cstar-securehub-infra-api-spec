# general

variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type = string
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) == 1
    )
    error_message = "Length must be 1 chars."
  }
}

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "Short Azure location identifier (e.g. itn)."
}

# MDC specific

variable "rate_limit_emd_product" {
  type        = number
  description = "Rate limit for MDC and TPP products."
}

variable "rate_limit_emd_message" {
  type        = number
  description = "Rate limit for EMD product."
}

variable "mdc_openid_url" {
  type        = string
  description = "OpenID discovery endpoint used for MDC validation."
}

variable "mdc_issuer_url" {
  type        = string
  description = "Issuer identifier for MDC token validation."
}
