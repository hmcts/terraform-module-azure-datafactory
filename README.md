# terraform-module-azure-datafactory

Terraform module for [Azure DataFactory](https://learn.microsoft.com/en-us/azure/data-factory/).

## Example

<!-- todo update module name -->
```hcl
module "datafactory" {
  source = "git@github.com:hmcts/terraform-module-azure-datafactory?ref=main"
  env    = var.env

  product   = "platops"
  component = "example"

  common_tags = module.common_tags.common_tags
}

# only for use when building from ADO and as a quick example to get valid tags
# if you are building from Jenkins use `var.common_tags` provided by the pipeline
module "common_tags" {
  source = "github.com/hmcts/terraform-module-common-tags?ref=master"

  builtFrom   = "hmcts/terraform-module-mssql"
  environment = var.env
  product     = "sds-platform"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.7.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_update_resource.approval](https://registry.terraform.io/providers/hashicorp/azapi/latest/docs/resources/update_resource) | resource |
| [azurerm_data_factory.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) | resource |
| [azurerm_data_factory_integration_runtime_azure.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_integration_runtime_azure) | resource |
| [azurerm_data_factory_linked_service_azure_blob_storage.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_blob_storage) | resource |
| [azurerm_data_factory_linked_service_azure_databricks.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_databricks) | resource |
| [azurerm_data_factory_linked_service_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_key_vault) | resource |
| [azurerm_data_factory_linked_service_sql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_sql_server) | resource |
| [azurerm_data_factory_managed_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_managed_private_endpoint) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.new](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azapi_resource.example_storage](https://registry.terraform.io/providers/hashicorp/azapi/latest/docs/data-sources/resource) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tag to be applied to resources | `map(string)` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | https://hmcts.github.io/glossary/#component | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment value | `string` | n/a | yes |
| <a name="input_existing_resource_group_name"></a> [existing\_resource\_group\_name](#input\_existing\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_linked_blob_storage"></a> [linked\_blob\_storage](#input\_linked\_blob\_storage) | Map of objects describing the blob storage accounts to link to the Data Factory. | <pre>map(object({<br>    connection_string        = string<br>    use_managed_identity     = optional(bool, true)<br>    description              = optional(string)<br>    integration_runtime_name = optional(string)<br>    annotations              = optional(list(string))<br>    parameters               = optional(map(any))<br>    additional_properties    = optional(map(any))<br>  }))</pre> | `{}` | no |
| <a name="input_linked_databricks"></a> [linked\_databricks](#input\_linked\_databricks) | Map of objects describing the DataBricks workspaces to link to the Data Factory. | <pre>map(object({<br>    databricks_workspace_id  = string<br>    databricks_workspace_url = string<br>    existing_cluster_id      = optional(string)<br>    new_cluster_config = optional(object({<br>      cluster_version       = string<br>      node_type             = string<br>      driver_node_type      = optional(string)<br>      init_scripts          = optional(list(string))<br>      log_destination       = optional(string)<br>      max_number_of_workers = optional(number, 2)<br>      min_number_of_workers = optional(number, 1)<br>      spark_config          = optional(map(string))<br>      spark_env_vars        = optional(map(string))<br>    }))<br>    description              = optional(string)<br>    integration_runtime_name = optional(string)<br>    annotations              = optional(list(string))<br>    parameters               = optional(map(any))<br>    additional_properties    = optional(map(any))<br>  }))</pre> | `{}` | no |
| <a name="input_linked_key_vaults"></a> [linked\_key\_vaults](#input\_linked\_key\_vaults) | Map of objects describing the KeyVaults to link to the Data Factory. | <pre>map(object({<br>    resource_id              = string<br>    description              = optional(string)<br>    integration_runtime_name = optional(string)<br>    annotations              = optional(list(string))<br>    parameters               = optional(map(any))<br>    additional_properties    = optional(map(any))<br>  }))</pre> | `{}` | no |
| <a name="input_linked_mssql_server"></a> [linked\_mssql\_server](#input\_linked\_mssql\_server) | Map of objects describing the SQL Servers to link to the Data Factory. | <pre>map(object({<br>    server_fqdn              = string<br>    database_name            = string<br>    description              = optional(string)<br>    integration_runtime_name = optional(string)<br>    annotations              = optional(list(string))<br>    parameters               = optional(map(any))<br>    additional_properties    = optional(map(any))<br>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Target Azure location to deploy the resource | `string` | `"UK South"` | no |
| <a name="input_managed_private_endpoints"></a> [managed\_private\_endpoints](#input\_managed\_private\_endpoints) | Map of objects describing the managed virtual network private endpoints to create. Required managed\_virtual\_network\_enabled to be true. | <pre>map(object({<br>    subresource_name = string<br>    resource_id      = string<br>  }))</pre> | `{}` | no |
| <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled) | Wether to enable managed virtual network for the Data Factory. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The default name will be product+component+env, you can override the product+component part by setting this | `string` | `null` | no |
| <a name="input_private_endpoint_enabled"></a> [private\_endpoint\_enabled](#input\_private\_endpoint\_enabled) | Wether to enable private endpoints for the Data Factory. | `bool` | `false` | no |
| <a name="input_private_endpoint_subnet_id"></a> [private\_endpoint\_subnet\_id](#input\_private\_endpoint\_subnet\_id) | The subnet ID to use for private endpoints. | `string` | `null` | no |
| <a name="input_product"></a> [product](#input\_product) | https://hmcts.github.io/glossary/#product | `string` | n/a | yes |
| <a name="input_public_network_enabled"></a> [public\_network\_enabled](#input\_public\_network\_enabled) | Whether to enable public network access to the Data Factory. | `bool` | `false` | no |
| <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id) | The ID of the Purview account to associated with this Data Factory. | `string` | `null` | no |
| <a name="input_system_assigned_identity_enabled"></a> [system\_assigned\_identity\_enabled](#input\_system\_assigned\_identity\_enabled) | Whether to enable System Assigned managed identity for the virtual machine. | `bool` | `false` | no |
| <a name="input_user_assigned_identity_ids"></a> [user\_assigned\_identity\_ids](#input\_user\_assigned\_identity\_ids) | List of User Manager Identity IDs to associate with the virtual machine. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
