param location string = resourceGroup().location
param name string
param appServicePlanId string
param dockerRegistryName string
@secure()
param dockerRegistryServerUserName string
@secure()
param dockerRegistryServerPassword string
param dockerRegistryImageName string
param dockerRegistryImageVersion string = 'latest'

@secure()
param dbHost string
@secure()
param dbUser string
@secure()
param dbPass string

param postgreSQLDatabaseName string

param appSettings array = [
  {
    name: 'DBHOST'
    value: dbHost
  }
  {
    name: 'DBUSER'
    value: dbUser
  }
  {
    name: 'DBPASS'
    value: dbPass
  }
  {
    name: 'DBNAME'
    value: postgreSQLDatabaseName
  }
]

param appCommandLine string = ''

var dockerAppSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${dockerRegistryName}.azurecr.io' }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: dockerRegistryServerUserName }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: dockerRegistryServerPassword }
  { name: 'SCM_DO_BUILD_DURING_DEPLOYMENT', value: 'true' }
]

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOCKER|${dockerRegistryName}.azurecr.io/${dockerRegistryImageName}:${dockerRegistryImageVersion}'
      alwaysOn: false
      ftpsState: 'FtpsOnly'
      appCommandLine: appCommandLine
      appSettings: union(appSettings, dockerAppSettings)
    }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
output systemAssignedIdentityPrincipalId string = appServiceApp.identity.principalId
