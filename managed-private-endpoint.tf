resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each           = var.managed_private_endpoints
  name               = "${local.name}-${each.key}-${var.env}"
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.resource_id
  subresource_name   = each.value.subresource_name
}

resource "null_resource" "private_endpoint_approvals" {
  for_each = var.managed_private_endpoints

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
                  az account set --subscription ${data.azurerm_subscription.current.subscription_id}
                  endpoints=$(az network private-endpoint-connection list --id ${each.value.resource_id} --query "[?starts_with(properties.privateLinkServiceConnectionState.description, 'Requested by DataFactory') && properties.privateLinkServiceConnectionState.status == 'Pending'].id" --output json)
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
  depends_on = [azurerm_data_factory_managed_private_endpoint.this]
}
