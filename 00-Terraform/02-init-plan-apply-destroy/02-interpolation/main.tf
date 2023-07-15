#Azure provider
provider "azurerm" {
  features {}
}

#create resource group
resource "azurerm_resource_group" "rg" {
    name     = "rg-terraexample"
    location = "westus2"
    tags      = {
      Environment = "terraexample"
    }
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-dev-westus2-001"
    address_space       = ["10.0.0.0/16","10.1.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}