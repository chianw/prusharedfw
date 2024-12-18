data "terraform_remote_state" "prufwtfstate" {
  backend = "azurerm"
  config = {
    resource_group_name  = "prutfstaterg"
    storage_account_name = "prutfstatesa123"
    container_name       = "tfstate"
    key                  = "prufw.tfstate"
  }
}



resource "azurerm_firewall_policy_rule_collection_group" "example" {
  name               = "lbu2-fwpolicy-rcg"
  firewall_policy_id = data.terraform_remote_state.prufwtfstate.outputs.azurerm_firewall_policy_id
  priority           = 600
  application_rule_collection {
    name     = "lbu2app_rule_collection1"
    priority = 500
    action   = "Deny"
    rule {
      name = "lbu2app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.10"]
      destination_fqdns = ["*.microsoft.com"]
    }
  }

  network_rule_collection {
    name     = "lbu2network_rule_collection1"
    priority = 400
    action   = "Deny"
    rule {
      name                  = "lbu2network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["10.0.0.11"]
      destination_addresses = ["192.168.1.1", "192.168.1.2"]
      destination_ports     = ["80", "1000-2000"]
    }
  }

  nat_rule_collection {
    name     = "lbu2nat_rule_collection1"
    priority = 300
    action   = "Dnat"
    rule {
      name                = "lbu2nat_rule_collection1_rule1"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["10.0.0.10", "10.0.0.12"]
      destination_address = data.terraform_remote_state.prufwtfstate.outputs.azurerm_public_ip_address
      destination_ports   = ["8080"]
      translated_address  = "192.168.0.1"
      translated_port     = "9000"
    }
  }
}