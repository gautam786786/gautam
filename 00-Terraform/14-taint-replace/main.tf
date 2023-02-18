
#Azure provider
provider "azurerm" {
  features {}
}


#create resource group
resource "azurerm_resource_group" "rqg" {
  name     = "rg-354ample"
  location = "westus2"
}

# terraform -replace="rg-354ample"
# terraform taint rg-354ample