param name string
param location string = resourceGroup().location
param keyVaultResourceId string
@secure()
param keyVaultSecretACRAdminUsername string
@secure()
param keyVaultSecretACRPass0 string
@secure()
param keyVaultSecretACRPass1 string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  } 
  
}

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(keyVaultResourceId)) {
  name: last(split((!empty(keyVaultResourceId) ? keyVaultResourceId : 'dummyVault'), '/'))!
}

// create a secret to store the container registry admin username
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecretACRAdminUsername)) {
  name: !empty(keyVaultSecretACRAdminUsername) ? keyVaultSecretACRAdminUsername : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().username
}
}
// create a secret to store the container registry admin password 0
resource secretAdminUserPassword0 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecretACRPass0)) {
  name: !empty(keyVaultSecretACRPass0) ? keyVaultSecretACRPass0 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
}
}
// create a secret to store the container registry admin password 1
resource secretAdminUserPassword1 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecretACRPass1)) {
  name: !empty(keyVaultSecretACRPass1) ? keyVaultSecretACRPass1 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[1].value
}
}

//Extra exercise: declare a deployed Key Vault as existing

//Extra exercise: store the Container Registry (username, password 0, password 1) as key vault secrets

#disable-next-line outputs-should-not-contain-secrets
output acrUsername string = containerRegistry.listCredentials().username
#disable-next-line outputs-should-not-contain-secrets
output acrPassword0 string = containerRegistry.listCredentials().passwords[0].value
#disable-next-line outputs-should-not-contain-secrets
output acrPassword1 string = containerRegistry.listCredentials().passwords[1].value
