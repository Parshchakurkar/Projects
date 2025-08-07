terraform {
  required_version = ">=0.12"
  required_providers {
    azapi = {
      source = "azure/azapi"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name = azurerm_resource_group.test_rg.name
    container_name = "tfstate"
    key = "terraform.tfstate"
    
  }
}



provider "azurerm" {
  features {}
}
