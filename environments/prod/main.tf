# c:\dev\repos\IaC\environments\prod\main.tf

provider "azurerm" {
  features {}
}

terraform {
  required_version = ">= 1.5"
}

# Example of using the network module
module "network" {
  source = "../../modules/network"
  # Pass variables to the network module for the prod environment
  # e.g., address_space = "10.0.0.0/16"
}
