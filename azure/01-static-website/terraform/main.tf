provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "storage_account" {
  source              = "./modules/storage_account"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_frontdoor" "fd" {
  name                = "myFrontDoor"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  frontend_endpoint {
    name      = "frontendEndpoint1"
    host_name = "mywebsite.azurefd.net"
  }

  backend_pool {
    name = "backendPool1"

    backend {
      host_header = module.storage_account.primary_web_endpoint
      address     = module.storage_account.primary_web_endpoint
      http_port   = 80
      https_port  = 443
    }
  }

  routing_rule {
    name               = "routingRule1"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["frontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "backendPool1"
    }
  }
}
