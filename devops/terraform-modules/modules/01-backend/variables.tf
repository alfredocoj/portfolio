variable "backend_resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "backend_storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "backend_container_name" {
  description = "The name of the container"
  type        = string
}

variable "backend_key" {
  description = "The key for the backend"
  type        = string
}