resource "azuread_application" "appname" {
  display_name = "${var.prefix_app_registration}-${var.application_name}-${var.environment}"
}