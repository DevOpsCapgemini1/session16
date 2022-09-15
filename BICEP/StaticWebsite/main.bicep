param storage_name string
param storage_sku string
param unique_id string = utcNow()
param scripts_repo_path string = 'https://github.com/DevOpsCapgemini1/session16'
param scripts_repo_branch string = 'main'
param identity_name string
var location = resourceGroup().location

var site = {
  index: 'index.html'
  error: 'error.html'
}

var source = {
  repo: {
    path: scripts_repo_path
    branch: scripts_repo_branch
  }
}
var assets = {
  raw: {
    path: replace(source.repo.path, 'github.com', 'raw.githubusercontent.com')
  }
}

var staticWebsite = {
  absolutePath: '${assets.raw.path}/${source.repo.branch}/script.sh'
  arguments: '--name ${storage_name} --index ${site.index} --error ${site.error}'

}

resource storage_account 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storage_name
  location: location
  sku: {
    name: storage_sku
  }
  kind: 'StorageV2'
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'static-website-deployment-script'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', identity_name)}': {
      }
    }
  }
  properties: {
    forceUpdateTag: unique_id
    azCliVersion: '2.30.0'
    arguments: staticWebsite.arguments
    primaryScriptUri: staticWebsite.absolutePath
    supportingScriptUris: []
    timeout: 'PT10M'
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
  }
  dependsOn: [
    storage_account
  ]
}

output website_url string = reference(storage_account.id, '2021-06-01', 'Full').properties.primaryEndpoints.web
