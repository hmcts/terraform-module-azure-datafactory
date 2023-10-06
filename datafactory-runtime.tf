resource "azurerm_data_factory_integration_runtime_azure" "this" {
  name                    = "AutoResolveIntegrationRuntime"
  data_factory_id         = azurerm_data_factory.this.id
  location                = "AutoResolve"
  virtual_network_enabled = var.managed_virtual_network_enabled
}
