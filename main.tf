resource "azurerm_resource_group" "rg1" {
  name     = var.name
  location = "Central India"

}
resource "azurerm_storage_account" "sa1" {
  depends_on               = [azurerm_resource_group.rg1]
  name                     = var.stg_name
  resource_group_name      = var.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg1, azurerm_storage_account.sa1]
  name                = var.vnet_name
  resource_group_name = var.name
  location            = var.location
  address_space       = var.vnet_address_space

}
resource "azurerm_subnet" "sub1" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = "subnet1"
  resource_group_name  = var.name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.vnet_address_space
}
resource "azurerm_network_interface" "nic1" {
  depends_on          = [azurerm_subnet.sub1]
  name                = var.nic
  resource_group_name = var.name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
  depends_on          = [azurerm_network_interface.nic1]
  name                = var.vm_name
  resource_group_name = var.name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "azureuser"
  admin_password      = "Password1234!"
   disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}