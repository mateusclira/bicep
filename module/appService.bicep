param location string = 'westus3'
param appServicePlanName string = 'appServicePlan'
param appServiceName string = 'appService${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var skuName = (environmentType == 'nonprod') ? 'F1' : 'P1'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
    name: appServicePlanName
    location: location
    sku: {
        name: skuName
    }
    kind: 'app'
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
    name: appServiceName
    location: location
    kind: 'app'
    properties: {
        serverFarmId: appServicePlan.id
    }
}

output appServiceHostName string = appService.properties.defaultHostName
