
param location string = resourceGroup().location
param appServiceName string
param appServicePlanName string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param MYSECRET string
param deployApp bool = true


var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'B1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appService 'Microsoft.Web/sites@2022-03-01' = if(deployApp) {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'MYSECRET'
          value: MYSECRET
        }
      ]
    }
    }
  }

output appService string = appService.properties.defaultHostName

