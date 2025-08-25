# c:\dev\repos\IaC\modules\function_app_linux\variables.tf

variable "config" {
  description = "Configuration for the Function App"
  type = object({
    name                        = string
    resource_group_name         = string
    app_settings                = map(string)
    site_config                 = any
    tags                        = map(string)
    slots = map(object({
      name         = string
      app_settings = map(string)
      site_config  = any
    }))
  })
}
