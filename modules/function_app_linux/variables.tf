# Variables (extended with validation for config)
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Resource location"
  type        = string
}

variable "function_app_name" {
  description = "Name of the Azure Function App"
  type        = string
}

variable "service_plan_id" {
  description = "App Service Plan ID"
  type        = string
}

variable "storage_account_name" {
  description = "Storage Account Name"
  type        = string
}

variable "storage_account_access_key" {
  description = "Storage Account Access Key"
  type        = string
  sensitive   = true
}

variable "identity_ids" {
  description = "List of User Assigned Managed Identity IDs (applied to main app and all slots)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "config" {
  description = <<EOT
Configuration object containing app_settings, site_config, and optional slots.

Example structure:
{
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = "your-connection-string"  # Recommended for monitoring
  },
  site_config = {
    always_on = false  # Best practice for Consumption plans
    application_stack = {
      python_version = "3.11"  # Explicit Linux runtime
    }
    minimum_tls_version = "1.2"  # Security best practice
  },
  slots = {
    staging = {
      app_settings = {
        "ENV" = "staging"
      },
      site_config = {
        always_on = false
      },
      sticky_settings = ["ENV"]  # Optional: Sticky app settings for safe slot swaps
    }
  }
}
EOT
  type = any
  
  validation {
    condition     = can(var.config.app_settings) && can(var.config.site_config)
    error_message = "Config must contain both 'app_settings' and 'site_config' objects."
  }
}

