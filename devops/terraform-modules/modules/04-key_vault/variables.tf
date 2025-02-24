variable "prefix_kv" {
  description = "The prefix of the key vault"
  type        = string
  default = "kv"
  
}

variable "location" {
  description = "The location of the key vault"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID"
  type        = string
}

variable "sku_name" {
  description = "The SKU name"
  type        = string
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
  default = "dev"
  
}