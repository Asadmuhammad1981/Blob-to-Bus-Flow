# Resource Group
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
   features {}
   subscription_id = "8b0422c9-d3b4-4ad5-b676-1cd162a61f87"  
}

resource "azurerm_resource_group" "rg" {
  name     = "bob-to-bus-flow"
  location = "West Europe"
}

# storage Account

resource "azurerm_storage_account" "stg" {
  name                     = "bobtobusflow"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  tags = {
    environment = "dev"
  }
}

# Service Bus Namespace

resource "azurerm_servicebus_namespace" "sbs_namespace" {
  name                = "sb-demo-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  tags = {
    environment = "dev"
    purpose     = "servicebus-demo"
  }
}

# Service Bus Topic

resource "azurerm_servicebus_topic" "sbs_topic" {
  name         = "blob-created-events"
  namespace_id = azurerm_servicebus_namespace.sbs_namespace.id
}

# Service Bus Topic Subscription to receive messages

resource "azurerm_servicebus_subscription" "sbs_subscription" {
  name               = "blob-created-sub"
  topic_id           = azurerm_servicebus_topic.sbs_topic.id
  max_delivery_count = 10
}

# Random string to make names unique

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Event Grid System Topic

# resource "azurerm_eventgrid_system_topic" "storage_events" {
#   name                = "egst-${azurerm_storage_account.stg.name}"
#   location            = azurerm_storage_account.stg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   source_resource_id  = azurerm_storage_account.stg.id
#   topic_type          = "Microsoft.Storage.StorageAccounts"
# }

# Event Grid Subscription → Send Blob Created events to Service Bus Topic

resource "azurerm_eventgrid_event_subscription" "to_servicebus" {
  name  = "blob-created-to-servicebus"
  scope = azurerm_storage_account.stg.id

  included_event_types                 = ["Microsoft.Storage.BlobCreated"]
  advanced_filtering_on_arrays_enabled = true
  service_bus_topic_endpoint_id        = azurerm_servicebus_topic.sbs_topic.id

}