resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = data.azuread_group.object_id_group.object_id

  secret_permissions = var.secret_permissions
  key_permissions = var.key_permissions
}

data "azuread_group" "object_id_group" {
  object_id = var.group_object_id
}