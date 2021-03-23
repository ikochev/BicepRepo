param serverfarms_IvanAppServicePlan_name string = 'IvanAppServicePlan'

resource serverfarms_IvanAppServicePlan_name_resource 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: serverfarms_IvanAppServicePlan_name
  location: 'West Europe'
  tags: {
    Environment: 'Dev'
    Project: 'Tutorial'
  }
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
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}