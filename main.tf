terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "rg-enterprise-prod"
  location = "germanywestcentral"
}

module "networking" {
  source = "./modules/networking"
  resource_group_name = azurerm_resource_group.rg.name

  hub_location = azurerm_resource_group.rg.location
  spoke_location = "francecentral"
}