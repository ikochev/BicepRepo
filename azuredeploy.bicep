@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

param location string = resourceGroup().location

param appServicePlanName string = 'farms1AppServicePlan'

@minLength(2)
@description('Base name of the resource such as web app name and app service plan.')
param webAppName string

@description('The Runtime stack of current web app')
param linuxFxVersion string = 'php|7.4'

@description('Tags that list the environment and the project')
param resourceTags object = {
  Environment: 'DevBicep'
  Project: 'BicepTutorial'
}

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'
var webAppPortalName = '${webAppName}${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: uniqueStorageName
  location: location
  tags: resourceTags
  sku:{
    name: storageSKU
  }
  kind:'StorageV2'
  properties: {
    supportsHttpsTrafficOnly:true
  }
}

resource serverFarms 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource site 'Microsoft.Web/sites@2020-06-01' = {
  name: webAppPortalName
  location: location
  tags: resourceTags
  kind: 'app'
  properties: {
    serverFarmId: serverFarms.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}


output storageEndpoints object = stg.properties.primaryEndpoints