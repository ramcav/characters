using '../main.bicep'

param appServiceContainerBackendName = 'rmendez-asc-backend' //Replace {alias} with your student alias to avoid deployment conflicts (e.g. alias of 'aguadamillas@faculty.ie.edu' is 'aguadamillas')
param appServicePlanName = 'rmendez-asp' //Replace {alias} with your student alias to avoid deployment conflicts (e.g. alias of 'aguadamillas@faculty.ie.edu' is 'aguadamillas')
param containerRegistryName = 'rmendezacr'  //Replace {alias} with your student alias to avoid deployment conflicts (e.g. alias of 'aguadamillas@faculty.ie.edu' is 'aguadamillas')
param postgreSQLDatabaseName = 'rmendez-db'  //Replace {alias} with your student alias to avoid deployment conflicts (e.g. alias of 'aguadamillas@faculty.ie.edu' is 'aguadamillas')
param postgreSQLServerName = 'rmendez-dbsrv'  //Replace {alias} with your student alias to avoid deployment conflicts (e.g. alias of 'aguadamillas@faculty.ie.edu' is 'aguadamillas')

// Exercise II (Option BICEP parameters): Add parameters to deploy the infrastructure. The names for the Azure resources must start with your student alias

// KEY VAULT

param keyVaultName = 'rmendez-kv'
// param keyVaultSku = 'standard'
// param keyVaultRoleAssignments =  [
//   {
//     principalId: '25d8d697-c4a2-479f-96e0-15593a830ae5' // BCSAI2024-DEVOPS-STUDENTS-A-SP
//     roleDefinitionIdOrName: 'Key Vault Secrets User'
//     principalType: 'ServicePrincipal'
//     }
//     {
//       principalId: 'a03130df-486f-46ea-9d5c-70522fe056de' // BCSAI2024-DEVOPS-STUDENTS-A
//       roleDefinitionIdOrName: 'Key Vault Administrator'
//       principalType: 'Group'
//       }
// ]
// param enableSoftDelete = true
// param enableVaultForDeployment = true

// APP SERVICE PLAN

param aspSKU = 'F1'

// APP SERVICE CONTAINER
param dockerRegistryImageName = 'rmendez-backend'
param dockerRegistryImageVersion = 'latest'

param ACRAdminUsernameSecretName = 'ACRusername'
param ACRPass0SecretName = 'ACRpass0'
param ACRPass1SecretName = 'ACRpass1'

// FlexibleSQL
param dbPass = 'placeholder'
param dbUser = 'placeholder'
param dbHost = 'rmendez-db.dbrsv.postgres.database.azure.com'


