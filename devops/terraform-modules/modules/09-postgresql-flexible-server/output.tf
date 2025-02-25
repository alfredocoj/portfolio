output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.db_name_postgresql_flexible_server.name
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.database_postgresql_flexible_server.name
}

output "postgresql_admin_password" {
  sensitive = true
  value = random_password.postgresql_admin_password.result
}