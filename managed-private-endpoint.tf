resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each           = var.managed_private_endpoints
  name               = "${local.name}-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.resource_id
  subresource_name   = each.value.subresource_name
}

# Retrieve the storage account details, including the private endpoint connections
data "azapi_resource" "example_storage" {
  type                   = "Microsoft.Storage/storageAccounts@2022-09-01"
  resource_id            = azurerm_storage_account.example.id
  response_export_values = ["properties.privateEndpointConnections"]
}

# Retrieve the private endpoint connection name from the storage account based on the private endpoint name
locals {
  private_endpoint_connection_name = element([
    for connection in jsondecode(data.azapi_resource.example_storage.output).properties.privateEndpointConnections
    : connection.name
    if endswith(connection.properties.privateEndpoint.id, azurerm_synapse_managed_private_endpoint.example.name)
  ], 0)
}

# Approve the private endpoint
resource "azapi_update_resource" "approval" {
  type      = "Microsoft.Storage/storageAccounts/privateEndpointConnections@2022-09-01"
  name      = local.private_endpoint_connection_name
  parent_id = azurerm_storage_account.example.id

  body = jsonencode({
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform"
        status      = "Approved"
      }
    }
  })
}
