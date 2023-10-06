resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each           = { for key, value in var.managed_private_endpoints : key => value if value.resource_id != null }
  name               = "${local.name}-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.resource_id
  subresource_name   = each.value.subresource_name
}
