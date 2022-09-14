param containerName string
param location string
param sku string
param networkAccess string

resource symbolicname 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: containerName
  location: location

  sku: {
    name: sku
  }
  properties: {
    publicNetworkAccess: networkAccess
  }

}
