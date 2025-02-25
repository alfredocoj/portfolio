variable "prefix_resource_group" {
  description = "The prefix of the resource group"
  type        = string
  default = "rg-us"
  
}

variable "landing_zone_acronym" {
  description = "The acronym of the landing zone"
  type        = string
  default = "main"
}

variable "name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
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