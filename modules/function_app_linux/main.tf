# Main Function App
resource "azurerm_linux_function_app" "main" {
  name                = var.function_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  # User-assigned managed identity (best practice for secure resource access)
  identity {
    type         = length(var.identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }

  # Simple assignment from config (as per your previous request)
  app_settings = var.config.app_settings
  site_config  = var.config.site_config

  # Best practice: Enforce HTTPS and TLS (Linux-specific security)
  https_only = true

  tags = var.tags

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],  # Ignore deployment package changes
    ]
  }
}

# Function App Slots (new addition using azurerm_linux_function_app_slot)
resource "azurerm_linux_function_app_slot" "slots" {
  for_each = try(var.config.slots, {})

  name                = each.key  # Use map key as slot name (e.g., "staging")
  function_app_id     = azurerm_linux_function_app.main.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  # User-assigned managed identity for each slot (same as main for consistency)
  identity {
    type         = length(var.identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids  # Can be overridden per slot if needed
  }

  # Simple assignment from slot configuration
  app_settings = lookup(each.value, "app_settings", {})
  site_config  = lookup(each.value, "site_config", {})

  # Best practice: Enforce HTTPS and TLS for slots
  https_only = true

  # Optional: Sticky settings for safe slot swaps (Microsoft best practice for zero-downtime)
  dynamic "sticky_settings" {
    for_each = lookup(each.value, "sticky_settings", []) != [] ? [1] : []
    content {
      app_setting_names = lookup(each.value, "sticky_settings", [])
    }
  }

  tags = var.tags

  depends_on = [azurerm_linux_function_app.main]
}
