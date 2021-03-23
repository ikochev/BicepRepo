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

param location string

@description('Tags that list the environment and the project')
param resourceTags object

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

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

output storageEndpoints object = stg.properties.primaryEndpoints