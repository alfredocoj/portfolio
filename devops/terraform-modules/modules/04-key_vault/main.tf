resource "azurerm_key_vault" "kv" {
  name                = "${var.prefix_kv}-${var.application_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name
  enabled_for_disk_encryption = true

  tags = merge({
    ApplicationName = var.application_name
    Environment     = var.environment
    Squad           = var.squad
    Tribe           = var.tribe
    StartDate       = var.start_date
  }, var.additional_tags)
}

data "azurerm_client_config" "current" {}