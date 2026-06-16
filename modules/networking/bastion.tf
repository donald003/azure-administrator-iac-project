resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-hub-bastion-ger"
  location            = var.hub_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "bas-hub-prod-ger"
  location            = var.hub_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "bastion-ip-configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}