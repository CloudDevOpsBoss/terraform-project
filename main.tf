resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location

}

resource "azurerm_resource_group" "rg1" {
  name     = local.resource_group_name #Demo-dev-rg
  location = local.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}-vnet" #Demo-dev-vnet
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]
   tags     = local.common_tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.prefix}-subnet" #Demo-dev-subnet
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "${local.prefix}-nsg" #Demo-dev-nsg
  location            = local.location
  resource_group_name = local.resource_group_name
  tags     = local.common_tags
}
resource "azurerm_network_security_rule" "nsg_rule" {
  name                        = "${local.prefix}-nsg-rule" #Demo-dev-nsg-rule
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
  
}
resource "azurerm_network_interface" "nic" {
  name                = "${local.prefix}-nic" #Demo-dev-nic
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "${local.prefix}-ipconfig" #Demo-dev-ipconfig
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "${local.prefix}-vm" #Demo-dev-vm
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D2als_v7"  
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

 
source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
  version   = "latest"
}

}



# resource "azurerm_storage_account" "sa" {
#   name                     = "demostorageacc41"
#   resource_group_name      = azurerm_resource_group.rg.name
#   location                 = azurerm_resource_group.rg.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

# }




