# Example usage in environments/dev/main.tf

module "function_app" {
  source = "../../modules/function_app_linux"

  config = {
    name                = "my-function-app-dev"
    resource_group_name = "my-resource-group-dev"

    # Application settings for the Function App
    app_settings = {
      FUNCTIONS_WORKER_RUNTIME = "python"
      SOME_SETTING             = "value"
    }

    # Site configuration for the Function App
    site_config = {
      always_on         = false
      application_stack = {
        python_version = "3.11"
      }
    }

    # Tags to apply to all resources
    tags = {
      environment = "dev"
    }

    # Deployment slots configuration
    slots = {
      staging = {
        name         = "staging"
        app_settings = { ENV = "staging" }
        site_config  = { always_on = false }
      }
      production = {
        name         = "production"
        app_settings = { ENV = "production" }
        site_config  = { always_on = true }
      }
    }
  }
}
