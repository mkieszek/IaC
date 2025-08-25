# c:\dev\repos\IaC\modules\function_app_linux\main.tf
data "azurerm_resource_group" "main" {
  name = var.config.resource_group_name
}

// Storage Account for the Function App
resource "azurerm_storage_account" "main" {
  name                     = var.config.storage_account_name
  resource_group_name      = data.azurerm_resource_group.main.name
  location                 = data.azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.config.log_analytics_workspace_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = local.log_analytics_workspace_config.sku
  retention_in_days   = local.log_analytics_workspace_config.retention_in_days
}

resource "azurerm_application_insights" "main" {
  name                = var.config.app_insights_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = local.application_insights_config.application_type
}

resource "azurerm_service_plan" "main" {
  name                = var.config.service_plan_name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = local.service_plan_config.os_type
  sku_name            = local.service_plan_config.sku_name
}

resource "azurerm_linux_function_app" "main" {
  name                = var.config.name
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  storage_account_name         = azurerm_storage_account.main.name
  storage_account_access_key   = azurerm_storage_account.main.primary_access_key

  service_plan_id = azurerm_service_plan.main.id
  https_only      = true

  app_settings = merge(
    var.config.app_settings,
    { "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string }
  )

  site_config = var.config.site_config

  tags = var.config.tags
}

resource "azurerm_function_app_slot" "slot" {
  for_each = var.config.slots

  name            = each.value.name
  function_app_id = azurerm_linux_function_app.main.id

  storage_account_name         = azurerm_storage_account.main.name
  storage_account_access_key   = azurerm_storage_account.main.primary_access_key

  app_settings = merge(
    each.value.app_settings,
    { "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.main.connection_string }
  )
  site_config = each.value.site_config

  # Make slot-specific app_settings sticky
  slot_settings = keys(each.value.app_settings)
}
