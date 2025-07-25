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
  description = "One of wue, neu"
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
}

variable "mil_introspect_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
}

variable "mil_get_jwks_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
}

variable "mil_get_access_token_rate_limit" {
  type = object({
    calls  = number
    period = number
  })
}

variable "mil_get_access_token_allowed_origins" {
  type = list(string)
}
