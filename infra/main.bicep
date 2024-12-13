// Exercise II: Configure the input parameters to set up your development environment
param appServiceContainerBackendName string
param appServicePlanName string
param containerRegistryName string
param keyVaultName string
param postgreSQLServerName string
param postgreSQLDatabaseName string
param location string = resourceGroup().location

// ASP

param aspSKU string

// AS CONTAINER

param dockerRegistryImageName string
param dockerRegistryImageVersion string

param ACRAdminUsernameSecretName string
param ACRPass0SecretName string
param ACRPass1SecretName string

// DB
@secure()
param dbPass string
@secure()
param dbUser string
@secure()
param dbHost string

// Exercise II: Configure the deployment of the appropriate modules for your hosting infrastructure. This is example code for a module deployment:
module keyVault 'modules/key-vault.bicep' = {
  name: keyVaultName
  params: {
    name: keyVaultName
    location: location
  }
}   
    

module containerRegistry 'modules/container-registry.bicep' = { //path to the module you want to deploy
  name: containerRegistryName //Always include your userAlias within the name of the module deployment in order to avoid conflicts with other student's deployment
  params: {
    //Configure the required parameters for your 
    keyVaultResourceId: keyVault.outputs.resourceId
    keyVaultSecretACRAdminUsername: ACRAdminUsernameSecretName
    keyVaultSecretACRPass0: ACRPass0SecretName
    keyVaultSecretACRPass1: ACRPass1SecretName
    name: containerRegistryName
    location: location

  }
  dependsOn: [
    //Set up the dependencies with other module
  ]
}

module postgresSQLServer 'modules/postgre-sql-server.bicep' = {
  name: postgreSQLServerName
  params: {
    name: postgreSQLServerName
    location: location
    administratorLogin: dbUser
    administratorPassword: dbPass
    keyVaultResourceId: keyVault.outputs.resourceId
    KVPasswordSecret: 'DBPASS'
    KVUsernameSecret: 'DBUSERNAME'
  }
  dependsOn: [
    appServiceContainer
  ]
}
module postgresSQLDatabase 'modules/postgre-sql-db.bicep' = {
name: postgreSQLDatabaseName 
params: {
  postgreSqlServerName: postgreSQLServerName
  name: postgreSQLDatabaseName 
}
dependsOn: [
  postgresSQLServer
]
}



module appServicePlan 'modules/app-service-plan.bicep' = {
  name: appServicePlanName
  params: {
    location: location
    appServicePlanName: appServicePlanName
    skuName: aspSKU
  }
}

resource keyVaultReference 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

  module appServiceContainer 'modules/app-service-container.bicep' = {
    name: appServiceContainerBackendName
    params: {
      name: appServiceContainerBackendName
      location: location
      appServicePlanId: appServicePlan.outputs.id
      appCommandLine: ''
      dockerRegistryName: containerRegistryName
      dockerRegistryServerUserName: keyVaultReference.getSecret(ACRAdminUsernameSecretName)
      dockerRegistryServerPassword: keyVaultReference.getSecret(ACRPass0SecretName)
      dockerRegistryImageName: dockerRegistryImageName
      dockerRegistryImageVersion: dockerRegistryImageVersion
      dbHost: dbHost
      dbPass: keyVaultReference.getSecret('DBPASS')
      dbUser: keyVaultReference.getSecret('DBUSERNAME')
      postgreSQLDatabaseName: postgreSQLDatabaseName
    }
    dependsOn: [
    containerRegistry
    keyVault
    ]
  }
