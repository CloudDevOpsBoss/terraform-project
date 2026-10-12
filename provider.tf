terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
# backend "azurerm" {
#   resource_group_name  = "demo-rg45"
#   storage_account_name = "demostorageacc41"
#   container_name       = "tfstate"
#   key                  = "terraform.tfstate"
# }

}

provider "azurerm" {
  features {}

}