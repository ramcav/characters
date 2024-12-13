param name string
param postgreSqlServerName string

resource postgresSQLDatabase 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-12-01' = {
  name: '${postgreSqlServerName}/${name}'
  properties: {
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
}
