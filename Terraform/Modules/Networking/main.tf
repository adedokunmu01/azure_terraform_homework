data "azurerm_resource_group" "example" {
  name = "Subscription_A"
}
data "azurerm_virtual_network" "example" {
  name = "Subscription_A"
}
data "azurerm_network_security_group" "example" {
  name = "example-resources"
}
resource "azurerm_virtual_network" "example" {
  name                = var.sub_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "example" {
  name                 = "Subnet_1"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [var.address_space]
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_network_security_rule" "example" {
  name                        = "test123"
  priority                    = module.last_priority.priority + 10
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "subscription_1"
  network_security_group_name = "Sub_1_NSG"
}
  
resource "azurerm_virtual_network_peering" "vnet-peer-1" {
name = "vnet1-vnet2"
resource_group_name           = data.azurerm_resource_group.example.rg_name
virtual_network_name          = data.azurerm_virtual_network.example.vnet_name
remote_virtual_network_id     = azurerm_virtual_network.example.id
allow_virtual_network_access  = "true"
allow_forwarded_traffic       = "true"
}

resource "azurerm_virtual_network_peering" "vnet-peer-2" {
name                         = "vnet2-vnet1"
resource_group_name          = var.resource_group.name
virtual_network_name         = azurerm_virtual_network.example.name
remote_virtual_network_id    = data.azurerm_virtual_network.example.vnet_id
allow_virtual_network_access = "true"
allow_forwarded_traffic      = "true"
}
