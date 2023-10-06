variable "existing_resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}

variable "location" {
  description = "Target Azure location to deploy the resource"
  type        = string
  default     = "UK South"
}

variable "name" {
  description = "The default name will be product+component+env, you can override the product+component part by setting this"
  type        = string
  default     = null
}

variable "purview_id" {
  description = "The ID of the Purview account to associated with this Data Factory."
  type        = string
  default     = null
}

variable "public_network_enabled" {
  description = "Whether to enable public network access to the Data Factory."
  type        = bool
  default     = false
}

variable "managed_virtual_network_enabled" {
  description = "Wether to enable managed virtual network for the Data Factory."
  type        = bool
  default     = true
}

variable "user_assigned_identity_ids" {
  description = "List of User Manager Identity IDs to associate with the virtual machine."
  type        = list(string)
  default     = []
}

variable "system_assigned_identity_enabled" {
  description = "Whether to enable System Assigned managed identity for the virtual machine."
  type        = bool
  default     = false
}

variable "private_endpoint_enabled" {
  description = "Wether to enable private endpoints for the Data Factory."
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "The subnet ID to use for private endpoints."
  type        = string
  default     = null
}

variable "managed_private_endpoints" {
  description = "Map of objects describing the managed virtual network private endpoints to create. Required managed_virtual_network_enabled to be true."
  type = map(object({
    subresource_name = string
    resource_id      = optional(string)
  }))
  default = {}
}

variable "linked_key_vaults" {
  description = "Map of objects describing the KeyVaults to link to the Data Factory."
  type = map(object({
    resource_id              = string
    description              = optional(string)
    integration_runtime_name = optional(string)
    annotations              = optional(list(string))
    parameters               = optional(map(any))
    additional_properties    = optional(map(any))
  }))
  default = {}
}

variable "linked_mssql_server" {
  description = "Map of objects describing the SQL Servers to link to the Data Factory."
  type = map(object({
    server_fqdn              = string
    database_name            = string
    description              = optional(string)
    integration_runtime_name = optional(string)
    annotations              = optional(list(string))
    parameters               = optional(map(any))
    additional_properties    = optional(map(any))
  }))
  default = {}
}

variable "linked_blob_storage" {
  description = "Map of objects describing the blob storage accounts to link to the Data Factory."
  type = map(object({
    connection_string        = string
    use_managed_identity     = optional(bool, true)
    description              = optional(string)
    integration_runtime_name = optional(string)
    annotations              = optional(list(string))
    parameters               = optional(map(any))
    additional_properties    = optional(map(any))
  }))
  default = {}
}

variable "linked_databricks" {
  description = "Map of objects describing the DataBricks workspaces to link to the Data Factory."
  type = map(object({
    databricks_workspace_id  = string
    databricks_workspace_url = string
    existing_cluster_id      = optional(string)
    new_cluster_config = optional(object({
      cluster_version       = string
      node_type             = string
      driver_node_type      = optional(string)
      init_scripts          = optional(list(string))
      log_destination       = optional(string)
      max_number_of_workers = optional(number, 2)
      min_number_of_workers = optional(number, 1)
      spark_config          = optional(map(string))
      spark_env_vars        = optional(map(string))
    }))
    description              = optional(string)
    integration_runtime_name = optional(string)
    annotations              = optional(list(string))
    parameters               = optional(map(any))
    additional_properties    = optional(map(any))
  }))
  default = {}
}
