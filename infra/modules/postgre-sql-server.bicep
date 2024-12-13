param location string = resourceGroup().location
param name string
@secure()
param administratorLogin string
@secure()
param administratorPassword string

param keyVaultResourceId string
@secure()
param KVUsernameSecret string
@secure()
param KVPasswordSecret string



resource postgresSQLServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    createMode: 'Default'
    highAvailability: {
      mode: 'Disabled'
      standbyAvailabilityZone: ''
    }
    storage: {
      storageSizeGB: 32
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    version: '15'
    authConfig: { activeDirectoryAuth: 'Disabled', passwordAuth: 'Enabled', tenantId: subscription().tenantId }
  }

  resource postgresSQLServerFirewallRules 'firewallRules@2022-12-01' = {
    name: 'AllowAllAzureServicesAndResourcesWithinAzureIps'
    properties: {
      endIpAddress: '0.0.0.0'
      startIpAddress: '0.0.0.0'
    }
  }
}

//Extra exercise: declare a deployed Key Vault as existing

//Extra exercise: store the FlexibleSQL Server Credentials (administratorLogin, administratorLoginPassword) as key vault secrets

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(keyVaultResourceId)) {
  name: last(split((!empty(keyVaultResourceId) ? keyVaultResourceId : 'dummyVault'), '/'))!
}

// create a secret to store the container registry admin username
resource secretUsername 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(KVUsernameSecret)) {
  name: !empty(KVUsernameSecret) ? KVUsernameSecret : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: administratorLogin
}
}

// create a secret to store the container registry admin username
resource secretPassword 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(KVPasswordSecret)) {
  name: !empty(KVPasswordSecret) ? KVPasswordSecret : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: administratorPassword
}
}


output id string = postgresSQLServer.id
