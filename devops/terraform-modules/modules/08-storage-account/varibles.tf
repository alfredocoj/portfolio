variable "resource_group_name" {
    description = "The name of the resource group in which to create the storage account."
    type        = string
}

variable "location" {
    description = "The location where the storage account will be created."
    type        = string
}

variable "storage_account_name" {
    description = "The name of the storage account."
    type        = string
}

variable "account_tier" {
    description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium."
    type        = string
    default     = "Standard"
}

variable "account_replication_type" {
    description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, and ZRS."
    type        = string
    default     = "LRS"
}

variable "application_name" {
  description = "The name of the application"
  type        = string
  
}

variable "squad" {
  description = "The squad"
  type        = string
}

variable "tribe" {
  description = "The tribe"
  type        = string
  
}

variable "start_date" {
  description = "The start date"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags"
  type        = map(string)
}

variable "environment" {
    description = "The environment"
    type        = string
    default     = "dev"
  
}