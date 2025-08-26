output "function_app_id" {
  description = "The ID of the Function App"
  value       = azurerm_linux_function_app.main.id
}

output "function_app_name" {
  description = "The name of the Function App"
  value       = azurerm_linux_function_app.main.name
}

output "function_app_identity" {
  description = "The managed identity of the Function App"
  value = {
    type         = azurerm_linux_function_app.main.identity[0].type
    principal_id = try(azurerm_linux_function_app.main.identity[0].principal_id, null)
    tenant_id    = try(azurerm_linux_function_app.main.identity[0].tenant_id, null)
  }
}

output "function_app_slots" {
  description = "Information about created slots"
  value = {
    for slot_name, slot in azurerm_linux_function_app_slot.slots : slot_name => {
      id               = slot.id
      name             = slot.name
      identity         = {
        type         = slot.identity[0].type
        principal_id = try(slot.identity[0].principal_id, null)
      }
    }
  }
}

output "slot_names" {
  description = "Names of all created slots"
  value       = keys(try(var.config.slots, {}))
}
