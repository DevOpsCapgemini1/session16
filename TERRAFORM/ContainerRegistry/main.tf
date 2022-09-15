terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}
provider "azurerm" {
  features {}
}
variable "name" {
  type = string
}

variable "location" {
  type = string
}
variable "sku" {
  type = string
}
variable "resource_group_name" {
  type = string
}
resource "azurerm_container_registry" "acr" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

}
