module "backend" {
  source = "../../modules/01-backend"
  backend_key = "your_backend_key"
  backend_resource_group_name = "your_backend_resource_group_name"
  backend_storage_account_name = "your_backend_storage_account_name"
  backend_container_name = "your_backend_container_name"
}

module "provider" {
  source = "../../modules/02-provider"
  subscription_id = "your_subscription_id"
  client_id = "your_client_id"
  client_secret = "your_client_secret"
  tenant_id = "your_tenant_id"
}

module "resource_group" {
  source = "../../modules/03-resource_group"
  location = "your_location"
  tribe = "your_tribe"
  application_name = "your_application_name"
  squad = "your_squad"
  start_date = "your_start_date"
  additional_tags = {
    tag1 = "value1"
    tag2 = "value2"
  }
  name = "your_name"
}

module "key_vault" {
  source = "../../modules/04-key_vault"
  tribe = "your_tribe"
  squad = "your_squad"
  additional_tags = {
    tag1 = "value1"
    tag2 = "value2"
  }
  application_name = "your_application_name"
  location = "your_location"
  sku_name = "your_sku_name"
  start_date = "your_start_date"
  resource_group_name = "your_resource_group_name"
  tenant_id = "your_tenant_id"
}