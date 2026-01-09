# Blob-to-Bus Flow

An event-driven Azure architecture demo built with **Terraform**.

**What it does**:  
When a file is uploaded to an Azure Storage Account container → Azure Event Grid automatically captures the `BlobCreated` event → sends a message to an Azure Service Bus Topic.

Perfect for learning serverless, event-driven patterns on Azure.

## Architecture
- Azure Storage Account (source)
- Event Grid Subscription (built-in system events)
- Azure Service Bus Namespace → Topic → Subscription (sink)

## How to Test Locally
1. `terraform init`
2. `terraform plan`
3. `terraform apply`
4. Create a container named `uploads` in the storage account
5. Upload any file
6. Go to Service Bus → Topic → Subscription → Peek messages → See the event!

## Built With
- Terraform (AzureRM provider)
- Azure Event Grid
- Azure Service Bus

Feel free to fork and extend — add Azure Functions, Logic Apps, or Power BI as consumers!

#Azure #Terraform #EventDriven #Serverless #CloudNative

High-Level Design (HLD) – Blob-to-Bus Flow Project
This is a simple, fully serverless event-driven architecture on Azure that demonstrates real-world integration patterns using Infrastructure as Code (Terraform).
Project Goal
When a file (blob) is uploaded to an Azure Storage Account container → automatically send an event message to Azure Service Bus Topic → ready for downstream processing (e.g., Function App, Logic App, or another system).
High-Level Architecture Diagram (Text Version)

+---------------------+          +---------------------------+
|   Azure Storage     |          |     Event Grid (built-in) |
|   Account           |  Blob    |     System Events         |
|   (Container:       | Created  |  (BlobCreated trigger)    |
|    uploads)         +--------->+---------------------------+
+---------------------+                   |
                                          v
                             +---------------------------+
                             | Azure Event Grid          |
                             | Event Subscription        |
                             +---------------------------+
                                          |
                                          v
                             +---------------------------+
                             | Azure Service Bus         |
                             | Namespace → Topic         |
                             | → Subscription (for peek) |
                             +---------------------------+
                                          |
                                          v (future extensions)
                             +---------------------------+
                             | Azure Function / Logic App|
                             | (consume & process event) |
                             +---------------------------+

                             Key Components Created by Terraform

Resource Group – Logical container
Storage Account – Source of events
Service Bus Namespace – Messaging backbone (Standard SKU for topics)
Service Bus Topic – Receives events
Service Bus Subscription – Allows peeking/testing messages
Event Grid Subscription – Routes BlobCreated events directly to Service Bus Topic (no custom system topic needed)

Data Flow

User uploads file → uploads container in Storage Account
Azure automatically emits Microsoft.Storage.BlobCreated event
Event Grid Subscription captures it
Message delivered to Service Bus Topic
Visible instantly via Portal (Peek) or consumable by any subscriber