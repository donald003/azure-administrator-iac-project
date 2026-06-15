output "hub_vnet_id" {
  value = azurerm_virtual_network.hub_vnet.id
  description = "The ID of the Hub Virtual Netowrk"
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke_vnet.id
  description = "The ID of the Spoke Virtual Netowrk"
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
  description = "The ID of the Bastion Subnet"
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
  description = "The ID of the Spoke Application Subnet for VM deployment"
}