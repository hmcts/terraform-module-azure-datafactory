data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

locals {
  name                    = var.name != null ? var.name : "${var.product}-${var.component}"
  is_prod                 = length(regexall(".*(prod).*", var.env)) > 0
  resource_group          = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].name : var.existing_resource_group_name
  resource_group_location = var.existing_resource_group_name == null ? azurerm_resource_group.new[0].location : var.location
  data_factory_name       = "${local.name}-${var.env}"
  identity                = var.system_assigned_identity_enabled == true || length(var.user_assigned_identity_ids) > 0 ? { identity = { type = (var.system_assigned_identity_enabled && length(var.user_assigned_identity_ids) > 0 ? "SystemAssigned, UserAssigned" : !var.system_assigned_identity_enabled && length(var.user_assigned_identity_ids) > 0 ? "UserAssigned" : "SystemAssigned"), identity_ids = var.user_assigned_identity_ids } } : {}

  dns_zone_id_prefix = "/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/"
  subresource_name_dns_zone_map = {
    dataFactory = "${local.dns_zone_id_prefix}privatelink.datafactory.azure.net"
    portal      = "${local.dns_zone_id_prefix}privatelink.adf.azure.com"
  }
}
