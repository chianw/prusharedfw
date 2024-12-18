terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.14.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "prutfstaterg"
    storage_account_name = "prutfstatesa123"
    container_name       = "tfstate"
    key                  = "prulbu1.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  use_oidc = true
}
