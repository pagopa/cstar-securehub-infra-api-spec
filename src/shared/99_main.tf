terraform {
  required_version = ">=1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.36.2
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=1b93c6b79180a2c28ac575ef85f9056f010c5ed2"
}
