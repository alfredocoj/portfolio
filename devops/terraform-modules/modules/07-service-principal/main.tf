# enterprise application
resource "azuread_service_principal" "appname_service_principal" {
  client_id               = azuread_application.appname.client_id
  app_role_assignment_required = false
  feature_tags {
    enterprise = true
    gallery    = false
  }
}