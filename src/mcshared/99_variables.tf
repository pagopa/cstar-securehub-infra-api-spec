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

variable "location" {
  type        = string
  description = "One of westeurope, northeurope"
}

variable "location_string" {
  type        = string
  description = "One of West Europe, North Europe"
}

variable "location_short" {
  type = string
  validation {
    condition = (
      length(var.location_short) == 3
    )
    error_message = "Length must be 3 chars."
  }
  description = "One of wue, neu"
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

# DNS
variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  description = "The dns subdomain."
}

variable "dns_zone_internal_prefix" {
  type        = string
  description = "The dns subdomain."
}

# MIL
variable "mil_auth_openapi_descriptor" {
  type = string
}

variable "mil_get_open_id_conf_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 100
    period = 60
  }
}

variable "mil_introspect_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 10
    period = 60
  }
}

variable "mil_get_jwks_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 100
    period = 60
  }
}

variable "mil_get_access_token_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
  default = {
    calls  = 10
    period = 60
  }
}

variable "mil_get_access_token_allowed_origins" {
  type = list(string)
}
