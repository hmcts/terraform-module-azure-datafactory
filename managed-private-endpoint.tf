resource "azurerm_data_factory_managed_private_endpoint" "purview" {
  count              = var.purview_id != "" && var.purview_id != null ? 1 : 0
  name               = "${local.name}-purview-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = var.purview_id
  subresource_name   = "account"
}

resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each           = var.managed_private_endpoints
  name               = "${local.name}-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.resource_id
  subresource_name   = each.value.subresource_name
}
