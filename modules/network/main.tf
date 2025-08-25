# c:\dev\repos\IaC\modules\network\main.tf

# Main configuration for the network module
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.env}"
  address_space       = [var.address_space]
  location            = var.location
  resource_group_name = var.resource_group_name
}
