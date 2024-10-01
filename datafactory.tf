resource "azurerm_data_factory" "this" {
  name                            = local.data_factory_name
  location                        = local.resource_group_location
  resource_group_name             = local.resource_group
  tags                            = var.common_tags
  public_network_enabled          = var.public_network_enabled
  purview_id                      = var.purview_id
  managed_virtual_network_enabled = var.managed_virtual_network_enabled

  dynamic "identity" {
    for_each = local.identity
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "global_parameter" {
    for_each = var.global_parameters
    content {
      name  = global_parameter.key
      value = global_parameter.value.value
      type  = global_parameter.value.type
    }
  }

  dynamic "github_configuration" {
    for_each = var.github_configuration
    content {
      account_name       = github_configuration.key
      branch_name        = github_configuration.value.branch_name
      git_url            = github_configuration.value.git_url
      repository_name    = github_configuration.value.repository_name
      root_folder        = github_configuration.value.root_folder
      publishing_enabled = github_configuration.value.publishing_enabled
    }
  }
}

resource "azurerm_private_endpoint" "this" {
  for_each            = toset(var.private_endpoint_enabled ? ["dataFactory", "portal"] : [])
  name                = "${local.name}-${each.key}-${var.env}"
  resource_group_name = local.resource_group
  location            = local.resource_group_location
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.common_tags

  private_service_connection {
    name                           = azurerm_data_factory.this.name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_data_factory.this.id
    subresource_names              = [each.key]
  }

  private_dns_zone_group {
    name                 = "endpoint-dnszonegroup"
    private_dns_zone_ids = [local.subresource_name_dns_zone_map[each.key]]
  }
}
