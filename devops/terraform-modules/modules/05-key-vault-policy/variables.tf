variable "key_vault_id" {
  description = "The ID of the key vault"
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID"
  type        = string
}

variable "group_object_id" {
  description = "The object ID of the Entra ID group. Example: gms.squad.estoque.devops"
  type        = string
}

variable "secret_permissions" {
  description = "The secret permissions"
  type        = list(string)
  default = ["Get","List","Set","Delete","Recover","Backup","Restore"]
}

variable "key_permissions" {
  description = "The key permissions"
  type        = list(string)
  default = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
}