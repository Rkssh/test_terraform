resource "azurerm_resource_group" "resource1" {
  name     = "myresource"
  location = "West Europe"
}

# my name is Dipu singh

resource "azurerm_virtual_network" "azvnet" {
  name                = "myvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource1.location
  resource_group_name = azurerm_resource_group.resource1.name
}

resource "azurerm_subnet" "azsubnet" {
  name                 = "internal_subnet"
  resource_group_name  = azurerm_resource_group.resource1.name
  virtual_network_name = azurerm_virtual_network.azvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "aznic" {
  name                = "aznic"
  location            = azurerm_resource_group.resource1.location
  resource_group_name = azurerm_resource_group.resource1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.azsubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "azlinux" {
  name                = "az_linux_machine"
  resource_group_name = azurerm_resource_group.resource1.name
  location            = azurerm_resource_group.resource1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Deep$ingh12"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.aznic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}