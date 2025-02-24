resource "azurerm_storage_account" "storage_account" {
    name                     = var.storage_account_name
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = var.account_tier
    account_replication_type = var.account_replication_type

    tags = merge({
        ApplicationName = var.application_name
        Environment     = var.environment
        Squad           = var.squad
        Tribe           = var.tribe
        StartDate       = var.start_date
    }, var.additional_tags)
}