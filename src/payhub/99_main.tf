terraform {
  required_version = ">=1.3.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "<= 2.51.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.107.0"
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

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.26.4
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=81c34fb63bbd2c8b275ac43df21863c344f85df2"
}
