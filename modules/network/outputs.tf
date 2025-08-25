# c:\dev\repos\IaC\modules\network\outputs.tf

output "vnet_id" {
  description = "The ID of the virtual network."
  value       = azurerm_virtual_network.main.id
}
