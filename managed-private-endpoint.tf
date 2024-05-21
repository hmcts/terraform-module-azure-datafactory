resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each           = { for key, value in var.managed_private_endpoints : key => value if value.is_managed_resource == false }
  name               = "${local.name}-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.resource_id
  subresource_name   = each.value.subresource_name

  timeouts {
    create = "60m"
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "dependants" {
  for_each           = { for key, value in var.managed_private_endpoints : key => value if value.is_managed_resource == true }
  name               = "${local.name}-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.resource_id
  subresource_name   = each.value.subresource_name

  timeouts {
    create = "60m"
  }

  depends_on = [azurerm_data_factory_managed_private_endpoint.this]
}

resource "null_resource" "private_endpoint_approvals" {
  for_each = { for key, value in var.managed_private_endpoints : key => value if value.is_managed_resource == false }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
                  az account set --subscription ${data.azurerm_subscription.current.subscription_id}
                  endpoints=$(az network private-endpoint-connection list --id ${each.value.resource_id} --query "[?starts_with(not_null(properties.privateLinkServiceConnectionState.description, ''), 'Requested by DataFactory') && properties.privateLinkServiceConnectionState.status == 'Pending'].id" --output json)
                  endpointsLength=$(echo "$endpoints" | jq "length - 1")
                  if [ $endpointsLength -lt 0 ]; then
                    echo "No pending private endpoint connections found."
                  else
                    for i in $(seq 0 $endpointsLength); do
                      endpoint=$(echo "$endpoints" | jq -r ".[$i]")
                      az network private-endpoint-connection approve --id $endpoint --description "Approved by Terraform via local-exec provisioner."
                    done
                  fi
    EOT
  }
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.this,
  ]
  lifecycle {
    replace_triggered_by = [
      azurerm_data_factory_managed_private_endpoint.this,
    ]
  }
}

resource "null_resource" "dependant_private_endpoint_approvals" {
  for_each = { for key, value in var.managed_private_endpoints : key => value if value.is_managed_resource == true }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
                  az account set --subscription ${data.azurerm_subscription.current.subscription_id}
                  endpoints=$(az network private-endpoint-connection list --id ${each.value.resource_id} --query "[?starts_with(not_null(properties.privateLinkServiceConnectionState.description, ''), 'Requested by DataFactory') && properties.privateLinkServiceConnectionState.status == 'Pending'].id" --output json)
                  endpointsLength=$(echo "$endpoints" | jq "length - 1")
                  if [ $endpointsLength -lt 0 ]; then
                    echo "No pending private endpoint connections found."
                  else
                    for i in $(seq 0 $endpointsLength); do
                      endpoint=$(echo "$endpoints" | jq -r ".[$i]")
                      az network private-endpoint-connection approve --id $endpoint --description "Approved by Terraform via local-exec provisioner."
                    done
                  fi
    EOT
  }
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.dependants
  ]
  lifecycle {
    replace_triggered_by = [
      azurerm_data_factory_managed_private_endpoint.dependants
    ]
  }
}
