resource "azurerm_virtual_network" "hub_vnet" {
  name = var.hub_network.name
  location = var.hub_location
  resource_group_name = var.resource_group_name
  address_space = var.hub_network.address_space
}

resource "azurerm_subnet" "bastion_subnet" {
  name = "AzureBastionSubnet"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes = var.hub_network.bastion_cidr
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name = "vnet-spoke-prod-fra"
  location = var.spoke_location
  resource_group_name = var.resource_group_name
  address_space = var.spoke_network.address_space
}

resource "azurerm_subnet" "app_subnet" {
  name = "snet-spoke-app"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes = var.spoke_network.app_cidr
}

resource "azurerm_subnet" "data_subnet" {
  name = "snet-spoke-data"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes = var.spoke_network.data_cidr
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name = "peer-hub-to-spoke"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name = "peer-spoke-to-hub"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic = true
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "nsg-spoke-app-fra"
  location            = var.spoke_location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = local.app_nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_network_security_group" "data_nsg" {
  name                = "nsg-spoke-data-fra"
  location            = var.spoke_location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = local.data_nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "app_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.app_nsg.id
  subnet_id = azurerm_subnet.app_subnet.id
}

resource "azurerm_subnet_network_security_group_association" "data_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.data_nsg.id
  subnet_id = azurerm_subnet.data_subnet.id
}

