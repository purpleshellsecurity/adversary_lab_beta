// modules/storage.bicep - Simple storage account for flow logs
@description('Location for all resources')
param location string

@description('Name prefix for resources')
param namePrefix string

@description('Storage account SKU')
param storageAccountSku string = 'Standard_LRS'

// Variables
var storageAccountName = '${toLower(namePrefix)}flowlogs${substring(uniqueString(resourceGroup().id), 0, 6)}'

// Storage Account for Flow Logs
resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
  tags: {
    Environment: 'Development'
    Project: namePrefix
    Purpose: 'FlowLogs'
  }
}

// Outputs
output storageAccountName string = storageAccount.name
output storageAccountResourceId string = storageAccount.id
output storageAccountPrimaryEndpoints object = storageAccount.properties.primaryEndpoints
