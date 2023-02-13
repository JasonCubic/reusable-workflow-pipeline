targetScope = 'subscription'

@description('Specifies the location/region for resources.')
param rgName string
param location string = 'eastus'
// param stNamePrefix string = 'storage'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
}

// // https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules
// module stg './storage.bicep' = {
//   name: 'storageDeployment'
//   scope: rg // Deployed in the scope of resource group we created above
//   params: {
//     location: rg.location
//     stNamePrefix: stNamePrefix
//   }
// }

// bug, what-if does not show sub-modules:  https://github.com/Azure/arm-template-whatif/issues/157
// az deployment sub create --subscription subscription-spoke-demo --location eastus --template-file main.bicep --what-if
