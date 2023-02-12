targetScope = 'resourceGroup'

param location string = resourceGroup().location
param namePrefix string = 'storage'

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name:'Standard_RAGRS'
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    // networkAcls: {
    //   bypass: 'AzureServices'
    //   // https://docs.bridgecrew.io/docs/set-default-network-access-rule-for-storage-accounts-to-deny
    //   defaultAction: 'Deny'
    //   ipRules: [
    //     {
    //       action: 'Allow'
    //       value: '10.0.0.0/8'
    //     }
    //     {
    //       action: 'Allow'
    //       value: '170.2.0.0/16'
    //     }
    //     {
    //       action: 'Allow'
    //       value: '53.0.0.0/8'
    //     }
    //   ]
    // }
  }
}

output storageAccountId string = storageAccount.id
