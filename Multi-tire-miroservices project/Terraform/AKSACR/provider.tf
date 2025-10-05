terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.111.0"
    }
  }
  required_version = ">= 1.3.0"

  backend "azurerm" {
    container_name       = "terraform"
    resource_group_name  = "multicontainer-rg"
    storage_account_name = "multitiesterraproject"
  }
}

provider "azurerm" {
  features {

  }
}
