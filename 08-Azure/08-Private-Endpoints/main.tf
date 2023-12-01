# https://thomasthornton.cloud/2023/10/30/setting-up-and-using-private-endpoints-in-azure-with-a-storage-account-example-in-terraform/

# Azure Private DNS Zone

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}
 
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "vnetlink"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

# What the above Terraform does:

# Creates an Azure Private DNS zone: privatelink.blob.core.windows.net
# Associates the private DNS zone with the already created VNet to allow for private DNS to work correctly

# Azure Storage Account with Private endpoint

# create storage account with blob storage
resource "azurerm_storage_account" "storage_account" {
  name                      = "tamopsstorageaccount"
  resource_group_name       = data.azurerm_resource_group.rg.name
  location                  = data.azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}
 
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "storage-endpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.endpoint.id
 
  private_service_connection {
    name                           = "storage-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }
 
  private_dns_zone_group {
    name                 = "storage-endpoint-connection"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
  }
 
  depends_on = [
    azurerm_storage_account.storage_account
  ]
}
 
resource "azurerm_private_dns_a_record" "storage_account" {
  name                = "storageaccount"
  zone_name           = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint.private_service_connection.0.private_ip_address]
}

# What the above Terraform does:

# Create an storage account: tamopsstorageaccount
# Creates private endpoint: storage-endpoint
# Adds private DNS record storageaccount to the private DNS zone privatelink.blob.core.windows.net