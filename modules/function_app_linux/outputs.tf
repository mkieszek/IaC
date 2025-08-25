# c:\dev\repos\IaC\modules\function_app_linux\outputs.tf

output "function_app_id" {
  description = "The ID of the Function App."
  value       = azurerm_linux_function_app.main.id
}

output "function_app_slot_ids" {
  description = "The IDs of the Function App slots."
  value       = { for k, v in azurerm_function_app_slot.slot : k => v.id }
}

output "function_app_name" {
  description = "The name of the Function App."
  value       = azurerm_linux_function_app.main.name
}

output "function_app_default_hostname" {
  description = "The default hostname of the Function App."
  value       = azurerm_linux_function_app.main.default_hostname
}
