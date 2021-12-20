param project string = 'mdwdo'
param env string = 'dev'
param location string = resourceGroup().location
param deployment_id string
param keyvault_owner_object_id string



module datafactory './modules/datafactory.bicep' = {
  name: 'datafactory_deploy_${deployment_id}'
  params: {
    project: project
    env: env
    location: location
    deployment_id: deployment_id
  }
}

module databricks './modules/databricks.bicep' = {
  name: 'databricks_deploy_${deployment_id}'
  params: {
    project: project
    env: env
    location: location
    deployment_id: deployment_id
    contributor_principal_id: datafactory.outputs.datafactory_principal_id
  }
}

module storage './modules/storage.bicep' = {
  name: 'storage_deploy_${deployment_id}'
  params: {
    project: project
    env: env
    location: location
    deployment_id: deployment_id
    contributor_principal_id: datafactory.outputs.datafactory_principal_id
  }
}



module keyvault './modules/keyvault.bicep' = {
  name: 'keyvault_deploy_${deployment_id}'
  params: {
    project: project
    env: env
    location: location
    deployment_id: deployment_id
    keyvault_owner_object_id: keyvault_owner_object_id
    datafactory_principal_id: datafactory.outputs.datafactory_principal_id
  }

  dependsOn: [
    datafactory
  ]
}




output storage_account_name string = storage.outputs.storage_account_name
output databricks_output object = databricks.outputs.databricks_output
output databricks_id string = databricks.outputs.databricks_id
output keyvault_name string = keyvault.outputs.keyvault_name
output keyvault_resource_id string = keyvault.outputs.keyvault_resource_id
output datafactory_name string = datafactory.outputs.datafactory_name
