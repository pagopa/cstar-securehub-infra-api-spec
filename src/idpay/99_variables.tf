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

variable "invitalia_fc" {
  type = string
}

variable "selfcare_base_url" {
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

variable "event_hub_port" {
  type    = number
  default = 9093
}

### External resources

# variable "monitor_resource_group_name" {
#   type        = string
#   description = "Monitor resource group name"
# }
#
# variable "log_analytics_workspace_name" {
#   type        = string
#   description = "Specifies the name of the Log Analytics Workspace."
# }
#
# variable "log_analytics_workspace_resource_group_name" {
#   type        = string
#   description = "The name of the resource group in which the Log Analytics workspace is located in."
# }


# variable "ingress_load_balancer_ip" {
#   type = string
# }

# variable "ingress_load_balancer_hostname" {
#   type = string
# }

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

variable "openid_config_url_mil" {
  type        = string
  description = "Token MIL, OIDC URL"
}

#
# PDV
#
variable "pdv_tokenizer_url" {
  type        = string
  description = "PDV uri. Endpoint for encryption of pii information."
}

variable "pdv_timeout_sec" {
  type        = number
  description = "PDV timeout (sec)"
}

variable "pdv_retry_count" {
  type        = number
  description = "PDV max retry number"
}

variable "pdv_retry_interval" {
  type        = number
  description = "PDV interval between each retry"
}

variable "pdv_retry_max_interval" {
  type        = number
  description = "PDV max interval between each retry"
}

variable "pdv_retry_delta" {
  type        = number
  description = "PDV delta"
}
#
# variable "checkiban_base_url" {
#   type        = string
#   default     = "127.0.0.1"
#   description = "Check IBAN uri."
# }
#
variable "selc_base_url" {
  type        = string
  description = "SelfCare api backend url"
}

variable "selc_timeout_sec" {
  type        = number
  description = "SelfCare api timeout (sec)"
  default     = 5
}
#
# variable "pm_service_base_url" {
#   type        = string
#   default     = "127.0.0.1"
#   description = "PM Service uri. Endpoint to retrieve Payment Instruments information."
# }
#
variable "pm_backend_url" {
  type        = string
  description = "Payment manager backend url (enrollment)"
}

variable "mil_openid_url" {
  type        = string
  description = "OpenId MIL url"
}

variable "mil_issuer_url" {
  type        = string
  description = " MIL issuer url"
}

# variable "webViewUrl" {
#   type        = string
#   description = "WebView Url"
# }
#
variable "pm_timeout_sec" {
  type        = number
  description = "Payment manager timeout (sec)"
}



#
# RTD reverse proxy
#
variable "reverse_proxy_rtd" {
  type        = string
  description = "AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller."
}
#
# #
# # SMTP Server
# #
# variable "mail_server_host" {
#   type        = string
#   description = "SMTP server hostname"
# }
#
# variable "mail_server_port" {
#   type        = string
#   default     = "587"
#   description = "SMTP server port"
# }
#
# variable "mail_server_protocol" {
#   type        = string
#   default     = "smtp"
#   description = "mail protocol"
# }
#
# # p7m self-signed certificate
# variable "enable_p7m_self_sign" {
#   type    = bool
#   default = true
# }
#
# variable "p7m_cert_validity_hours" {
#   type    = number
#   default = 87600 # 10 year
#
# }
#
# variable "idpay_mocked_merchant_enable" {
#   type        = bool
#   description = "Enable mocked merchant APIs"
#   default     = false
# }
#
variable "idpay_mocked_acquirer_apim_user_id" {
  type        = string
  description = "APIm user id of mocked acquirer"
  default     = null
}
#
# variable "aks_cluster_domain_name" {
#   type        = string
#   description = "Name of the aks cluster domain. eg: dev01"
# }
#
# variable "enable" {
#   type = object({
#     mock_io_api = bool
#   })
#   description = "Feature flags"
#   default = {
#     mock_io_api = false
#   }
# }
#
# variable "rate_limit_io_product" {
#   type        = number
#   description = "Rate limit for IO product"
#   default     = 2500
# }
#
variable "rate_limit_issuer_product" {
  type        = number
  description = "Rate limit for Issuer product"
  default     = 2000
}
#
variable "rate_limit_assistance_product" {
  type        = number
  description = "Rate limit for Assistance product"
}
#
variable "rate_limit_mil_citizen_product" {
  type        = number
  description = "Rate limit for MIL citizen product"
}
#
variable "rate_limit_mil_merchant_product" {
  type        = number
  description = "Rate limit for MIL merchant product"
}
#
variable "rate_limit_minint_product" {
  type        = number
  description = "Rate limit for MIN INT product"
}
#
variable "rate_limit_portal_product" {
  type        = number
  description = "Rate limit for institutions portal product"
}
#
variable "rate_limit_merchants_portal_product" {
  type        = number
  description = "Rate limit for merchants portal product"
}
variable "rate_limit_users_portal_product" {
  type        = number
  description = "Rate limit for user portal product"
}

#
# IO
#
#APP IO
variable "appio_timeout_sec" {
  type        = number
  description = "AppIo timeout (sec)"
}

variable "rate_limit_io_product" {
  type        = number
  description = "Rate limit for IO product"
}

variable "webViewUrl" {
  type        = string
  description = "WebView Url"
}

variable "enable_flags" {
  type = object({
    mock_io_api     = bool
    mocked_merchant = bool
  })
  description = "Feature flags"

}
variable "keycloak_url_merchant_op" {
  type        = string
  description = "Keycloak URL for merchant op realm"
}

variable "keycloak_url_user" {
  type        = string
  description = "Keycloak URL for user realm"
}
