output "resource_group_name" {
  value = local.resource_group
}

output "resource_group_location" {
  value = local.resource_group_location
}

output "id" {
  value = azurerm_data_factory.this.id
}

output "identity" {
  value = azurerm_data_factory.this.identity[0]
}
