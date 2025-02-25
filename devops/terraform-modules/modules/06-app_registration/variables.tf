variable "application_name" {
  description = "The name of the app registration"
  type        = string
}

variable "homepage" {
  description = "The homepage URL"
  type        = string
}

variable "identifier_uris" {
  description = "The identifier URIs"
  type        = list(string)
}

variable "reply_urls" {
  description = "The reply URLs"
  type        = list(string)
}

variable "available_to_other_tenants" {
  description = "Whether the app is available to other tenants"
  type        = bool
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
  default = "dev" 
}

variable "prefix_app_registration" {
  description = "The prefix for the app registration name"
  type        = string
  default = "app" 
}