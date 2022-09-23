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
variable "storageaccountname" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  type = map(any)
}
variable "name_of_user_assigned_identity" {
  type = string
}

resource "azurerm_storage_account" "example" {
  name                     = var.storageaccountname
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.sku.account_tier
  account_replication_type = var.sku.account_replication_type
  account_kind             = "StorageV2"
}
data "azurerm_resource_group" "example" {
  name = var.resource_group_name
}
data "azurerm_user_assigned_identity" "example" {
  name                = var.name_of_user_assigned_identity
  resource_group_name = var.resource_group_name
}

resource "random_id" "random_deployment_suffix" {
  byte_length = 4
}

resource "azapi_resource" "symbolicname" {
  type      = "Microsoft.Resources/deploymentScripts@2020-10-01"
  name      = "${storageaccountname}-website"
  location  = var.location
  parent_id = data.azurerm_resource_group.example.id

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.id]
  }

  kind = "AzureCLI"
  properties = {
    arguments            = "--name ${var.storageaccountname} --index index.html --error error.html"
    azCliVersion         = "2.30.0"
    cleanupPreference    = "Always"
    forceUpdateTag       = "uniquestring${random_id.random_deployment_suffix.hex}"
    primaryScriptUri     = "https://raw.githubusercontent.com/DevOpsCapgemini1/session16/main/script.sh"
    retentionInterval    = "P1D"
    supportingScriptUris = []
    timeout              = "PT10M"
  }
}
