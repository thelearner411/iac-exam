@sys.description('The web app name for the backend.')
@minLength(3)
@maxLength(30)
param appServiceName string = 'mcollins-app'

@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName string = 'mcollins-asp'

param storageAccountNames array = [
  'mcollinsfinalexam1'
  'mcollinsfinalexam2'
]

@allowed([
  'nonprod'
  'prod'
  ])
param environmentType string = 'nonprod'
param location string = resourceGroup().location
param deployApp bool = true


var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'  

resource storageAccountResources 'Microsoft.Storage/storageAccounts@2022-05-01' = [for storageAccountName in storageAccountNames : if (deployApp) {
    name: storageAccountName
    location: location
    sku: {
      name: storageAccountSkuName
    }
    kind: 'StorageV2'
    properties: {
      accessTier: 'Hot'
    }
  }]

  @secure()
  param MYSECRET string


module appService 'modules/appStuff.bicep' = {
  name: 'appService'
  params: { 
    location: location
    appServiceName: appServiceName
    appServicePlanName: appServicePlanName
    environmentType: environmentType
    MYSECRET: MYSECRET
  }
}

  output appService string = appService.outputs.appService



    