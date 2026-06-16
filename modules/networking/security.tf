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

