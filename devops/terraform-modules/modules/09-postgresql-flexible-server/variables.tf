variable "server_name" {
    description = "The name of the PostgreSQL Flexible Server"
    type        = string
}

variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
}

variable "location" {
    description = "The location of the resource group"
    type        = string
}

variable "postgresql_version" {
    description = "The version of PostgreSQL to use"
    type        = string
    default = "14"
}

variable "administrator_login" {
    description = "The administrator login name for the PostgreSQL Flexible Server"
    type        = string
    default = "psqladmin"
}

variable "administrator_password" {
    description = "The administrator password for the PostgreSQL Flexible Server"
    type        = string
    sensitive   = true
}

variable "sku_name" {
    description = "The SKU name for the PostgreSQL Flexible Server"
    type        = string
    default = "GP_Standard_D2s_v3"
}

variable "storage_mb" {
    description = "The storage size in MB for the PostgreSQL Flexible Server"
    type        = number
}

variable "backup_retention_days" {
    description = "The number of days to retain backups"
    type        = number
    default = 14
}

variable "geo_redundant_backup_enabled" {
    description = "Whether or not geo-redundant backup is enabled"
    type        = string
    default = "false"
}

variable "delegated_subnet_id" {
    description = "The ID of the delegated subnet"
    type        = string
}

variable "zone" {
    description = "The zone in which the PostgreSQL Flexible Server should be created"
    type        = string
    default     = "1"
}

variable "create_mode" {
    description = "The create mode for the PostgreSQL Flexible Server"
    type        = string
    default     = "Default"
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