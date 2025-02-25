include {
  path = find_in_parent_folders()
}

inputs = {
  resource_group_name   = "dev-rg"
  prefix_resource_group = "rg-br-gms-"
  environment           = "prod"
  storage_account_name  = "devstorageaccount"
  container_name        = "tfstate"
  key                   = "dev.tfstate"
  subscription_id       = "your-subscription-id"
  client_id             = "your-client-id"
  client_secret         = "your-client-secret"
  tenant_id             = "your-tenant-id"
  location              = "East US"
  key_vault_name        = "dev-kv"
  key_vault_sku         = "standard"
  app_registration_name = "dev-app"
  service_principal_id  = "your-service-principal-id"
}