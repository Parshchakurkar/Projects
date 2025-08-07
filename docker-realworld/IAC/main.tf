resource "azurerm_resource_group" "test_rg" {
  name     = var.azurerm_resource_group_name
  location = var.location
}

#VNET

resource "azurerm_virtual_network" "test_linux_vnet" {
  name                = "test-linux-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name
}

#subnet

resource "azurerm_subnet" "test_linux_subnet" {
  name                 = "test-linux_subnet"
  resource_group_name  = azurerm_resource_group.test_rg.name
  virtual_network_name = azurerm_virtual_network.test_linux_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#public IP
resource "azurerm_public_ip" "test_linux_ip" {
  name                = "test-linux_ip"
  resource_group_name = azurerm_resource_group.test_rg.name
  allocation_method   = "Static"
  location            = azurerm_resource_group.test_rg.location
  depends_on          = [azurerm_resource_group.test_rg]
}

#NIC : network interface

resource "azurerm_network_interface" "test_linux_nic" {
  name                = "test-linux-nic"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  ip_configuration {
    name                          = "test-linux_ip"
    subnet_id                     = azurerm_subnet.test_linux_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.test_linux_ip.id
  }
  depends_on = [azurerm_public_ip.test_linux_ip, azurerm_virtual_network.test_linux_vnet]
}
#NSG : network security group 
resource "azurerm_network_security_group" "test_nsg" {
  name                = "test_linux_nsg"
  location            = azurerm_resource_group.test_rg.location
  resource_group_name = azurerm_resource_group.test_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#vm
resource "azurerm_linux_virtual_machine" "test_vm" {
  name                = "test-linux"
  resource_group_name = azurerm_resource_group.test_rg.name
  location            = azurerm_resource_group.test_rg.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.test_linux_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/Users/parsh/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

