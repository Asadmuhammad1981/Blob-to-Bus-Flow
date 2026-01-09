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