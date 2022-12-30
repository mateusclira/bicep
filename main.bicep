param location string = 'westus3'
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'
param appServiceName string = 'appService${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var skuName = (environmentType == 'nonprod') ? 'Standard_LRS' : 'Standard_GRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: skuName
  }
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'module/appService.bicep' = {
  name: appServiceName
  params: {
    location: location
    appServiceName: appServiceName
    environmentType: environmentType
  }
}

output appServiceHostName string = appService.outputs.appServiceHostName
