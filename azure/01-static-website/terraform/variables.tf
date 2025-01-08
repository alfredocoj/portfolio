variable "resource_group_name" {
  description = "Nome do grupo de recursos"
  type        = string
}

variable "location" {
  description = "Localização da Azure"
  type        = string
  default     = "West Europe"
}
