resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix_resource_group}-${var.landing_zone_acronym}-${var.application_name}-${var.environment}"
  location = var.location

  tags = merge({
    ApplicationName = var.application_name
    Environment     = var.environment
    Squad           = var.squad
    Tribe           = var.tribe
    StartDate       = var.start_date
  }, var.additional_tags)
}