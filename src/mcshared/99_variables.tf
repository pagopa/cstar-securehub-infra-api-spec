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

variable "aks_legacy_instance_name" {
  type        = string
  description = "Instance name"
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
