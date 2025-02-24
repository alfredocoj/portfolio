resource "random_password" "postgresql_admin_password" {
  length           = 20
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_flexible_server" "db_name_postgresql_flexible_server" {
    name                = "${var.server_name}-${var.environment}"
    resource_group_name = var.resource_group_name
    location            = var.location
    version             = var.postgresql_version
    zone = var.zone
    create_mode                  = var.create_mode
    administrator_login          = var.administrator_login # variável usada para definir o usuário admin do database.
    administrator_password       = random_password.postgresql_admin_password.result
    storage_mb                   = var.storage_mb # variável para especificar a quantidade de armazenamento desejado para o servidor.

    sku_name   = var.sku_name

    ## backup
    backup_retention_days = var.backup_retention_days
    geo_redundant_backup_enabled  = var.geo_redundant_backup_enabled

    # network
    delegated_subnet_id = var.delegated_subnet_id

    tags = merge({
        ApplicationName = var.application_name
        Environment     = var.environment
        Squad           = var.squad
        Tribe           = var.tribe
        StartDate       = var.start_date
    }, var.additional_tags)
}

resource "azurerm_postgresql_flexible_server_database" "database_postgresql_flexible_server" {
  name      = "database-flexible-server"
  server_id = azurerm_postgresql_flexible_server.db_name_postgresql_flexible_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}