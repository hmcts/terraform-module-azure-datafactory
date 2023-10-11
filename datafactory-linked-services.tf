resource "azurerm_data_factory_linked_service_key_vault" "this" {
  for_each                 = var.linked_key_vaults
  name                     = each.key
  data_factory_id          = azurerm_data_factory.this.id
  key_vault_id             = each.value.resource_id
  integration_runtime_name = each.value.integration_runtime_name
  description              = each.value.description
  annotations              = each.value.annotations
  parameters               = each.value.parameters
  additional_properties    = each.value.additional_properties

  depends_on = [azurerm_data_factory_managed_private_endpoint.this, null_resource.private_endpoint_approvals]
}

resource "azurerm_data_factory_linked_service_sql_server" "this" {
  for_each                 = var.linked_mssql_server
  name                     = each.key
  data_factory_id          = azurerm_data_factory.this.id
  connection_string        = "Integrated Security=False;Encrypt=True;Connection Timeout=30;Data Source=${each.value.server_fqdn}"
  integration_runtime_name = each.value.integration_runtime_name
  description              = each.value.description
  annotations              = each.value.annotations
  parameters               = each.value.parameters
  additional_properties    = each.value.additional_properties

  depends_on = [azurerm_data_factory_managed_private_endpoint.this, null_resource.private_endpoint_approvals]
}

resource "azurerm_data_factory_linked_service_azure_sql_database" "this" {
  for_each                 = var.linked_mssql_databases
  name                     = each.key
  data_factory_id          = azurerm_data_factory.this.id
  use_managed_identity     = each.value.use_managed_identity
  connection_string        = "Integrated Security=False;Encrypt=True;Connection Timeout=30;Data Source=${each.value.server_fqdn};Initial Catalog=${each.value.database_name}"
  integration_runtime_name = each.value.integration_runtime_name
  description              = each.value.description
  annotations              = each.value.annotations
  parameters               = each.value.parameters
  additional_properties    = each.value.additional_properties

  depends_on = [azurerm_data_factory_managed_private_endpoint.this, null_resource.private_endpoint_approvals]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "this" {
  for_each                 = var.linked_blob_storage
  name                     = each.key
  data_factory_id          = azurerm_data_factory.this.id
  connection_string        = each.value.connection_string
  service_endpoint         = each.value.service_endpoint
  use_managed_identity     = each.value.use_managed_identity
  integration_runtime_name = each.value.integration_runtime_name
  description              = each.value.description
  annotations              = each.value.annotations
  parameters               = each.value.parameters
  additional_properties    = each.value.additional_properties

  depends_on = [azurerm_data_factory_managed_private_endpoint.this, null_resource.private_endpoint_approvals]
}

resource "azurerm_data_factory_linked_service_azure_databricks" "this" {
  for_each        = var.linked_databricks
  name            = each.key
  data_factory_id = azurerm_data_factory.this.id

  adb_domain = "https://${each.value.databricks_workspace_url}"

  msi_work_space_resource_id = each.value.databricks_workspace_id
  existing_cluster_id        = each.value.existing_cluster_id
  integration_runtime_name   = each.value.integration_runtime_name
  description                = each.value.description
  annotations                = each.value.annotations
  parameters                 = each.value.parameters
  additional_properties      = each.value.additional_properties

  dynamic "new_cluster_config" {
    for_each = each.value.new_cluster_config != null ? [each.value.new_cluster_config] : []
    content {
      cluster_version             = new_cluster_config.value.cluster_version
      node_type                   = new_cluster_config.value.node_type
      custom_tags                 = var.common_tags
      driver_node_type            = new_cluster_config.value.driver_node_type
      init_scripts                = new_cluster_config.value.init_scripts
      log_destination             = new_cluster_config.value.log_destination
      max_number_of_workers       = new_cluster_config.value.max_number_of_workers
      min_number_of_workers       = new_cluster_config.value.min_number_of_workers
      spark_config                = new_cluster_config.value.spark_config
      spark_environment_variables = new_cluster_config.value.spark_env_vars
    }
  }

  depends_on = [azurerm_data_factory_managed_private_endpoint.this, null_resource.private_endpoint_approvals]
}
