# c:\dev\repos\IaC\modules\network\variables.tf

variable "address_space" {
  description = "The address space for the virtual network."
  type        = string
}

variable "env" {
  description = "The environment name."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}
