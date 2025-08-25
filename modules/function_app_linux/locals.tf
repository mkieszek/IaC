# c:\dev\repos\IaC\modules\function_app_linux\locals.tf

locals {
  # Primary configuration object for the Function App module
  config = var.config

  log_analytics_workspace_config = {
    sku               = "PerGB2018"
    retention_in_days = 30
  }

  application_insights_config = {
    application_type = "web"
  }
  
  service_plan_config = {
    os_type = "Linux"
    sku_name = "Y1"
  }
}
