
module "rg1" {
  source = "../../modules/azurerm_resource_group"
  #for_each = var.rgname
  rgname = {
    rg1 = {
      name     = "${local.environment}-ind_devops"
      location = "central india"
    }
    # rg2 = {
    #   name     = "ind_devops_02"
    #   location = "east us"
    # }
  }
}

module "vnet" {
  source     = "../../modules/azurerm_virtual_network"
  depends_on = [module.rg1]
  #for_each = var.vnet
  vnet = {
    v1 = {
      name                = "${local.environment}-vnet001"
      location            = "central india"
      resource_group_name = "${local.environment}-ind_devops"
      address_space       = ["10.0.0.0/25"]
    }
  }

}

module "subnet" {
  source     = "../../modules/azurerm_subnet"
  depends_on = [module.rg1, module.vnet]
  ##for_each = var.subnet
  subnet = {
    s1 = {
      name                 = "${local.environment}-subnet01"
      resource_group_name  = "${local.environment}-ind_devops"
      virtual_network_name = "${local.environment}-vnet001"
      address_prefixes     = ["10.0.0.0/26"]
    }
  }
}

module "nsg" {
  source     = "../../modules/azurerm_network_security_group"
  depends_on = [module.rg1, module.subnet,module.vnet]
  nsg = {
    nsg1 = {
      name                = "${local.environment}-nsg01"
      resource_group_name = "${local.environment}-ind_devops"
      location            = "central india"
    }

  }
  security_rule = {
    security_rule1 = {
      rule_name                  = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    security_rule2 = {
      rule_name                  = "http"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    security_rule3 = {
      rule_name                  = "https"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  nsg_asso = {
    nsg_asso1 = {
      subnet_id                 = module.subnet.subnet["s1"]
      network_security_group_id = module.nsg.nsg_id["nsg1"]
    }
  }
}

module "vm" {
  source     = "../../modules/azurerm_virtual_machine"
  depends_on = [module.rg1, module.subnet, module.vnet, module.nsg]
  #for_each = var.vms
  vms = {
    vm1 = {
      name                = "${local.environment}nic01"
      location            = "central india"
      resource_group_name = "${local.environment}-ind_devops"
      subnet_id           = module.subnet.subnet["s1"]

      vmname               = "${local.environment}-Forntend01"
      size                 = "Standard_B1s"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      publisher            = "canonical"
      offer                = "0001-com-ubuntu-server-jammy"
      sku                  = "22_04-lts"
      version              = "latest"

      vmusername = data.azurerm_key_vault_secret.vm_username.value
      vmpassword = data.azurerm_key_vault_secret.vm_password.value
    }
    vm2 = {
      name                = "${local.environment}nic02"
      location            = "central india"
      resource_group_name = "${local.environment}-ind_devops"
      subnet_id           = module.subnet.subnet["s1"]

      vmname               = "${local.environment}-Backendvm02"
      size                 = "Standard_B1s"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      publisher            = "canonical"
      offer                = "0001-com-ubuntu-server-jammy"
      sku                  = "22_04-lts"
      version              = "latest"

      vmusername = data.azurerm_key_vault_secret.vm_username.value
      vmpassword = data.azurerm_key_vault_secret.vm_password.value
    }
  }
}

module "sqlserver" {
  source = "../../modules/azurerm_sql_server"
  depends_on = [ module.rg1,module.vnet,module.vm ]
  sqlserver = {
    sql1 = {
      name                = "${local.environment}sqlserverglb"
      resource_group_name = "${local.environment}-ind_devops"
      location            = "central india"
      version             = "12.0"
      vmusername          = data.azurerm_key_vault_secret.vm_username.value
      vmpassword          = data.azurerm_key_vault_secret.vm_password.value
    }
  }
}

module "database" {
  source="../../modules/azurerm_sql_database"
  depends_on = [ module.rg1,module.sqlserver,module.vm,module.vnet ]

    sqldatabase = {
    sqldb1 = {
      dbname = "${local.environment}sqldatabase001"
      server_id = module.sqlserver.server_id["sql1"]
      collation    = "SQL_Latin1_General_CP1_CI_AS"
      license_type = "LicenseIncluded"
    }
  }
  sqlconnect = {
    allow_ip1 = {
      rule_name="${local.environment}allowaccess"
     server_id = module.sqlserver.server_id["sql1"]
      start_ip_address = "192.168.68.107"
      end_ip_address   = "192.168.68.107"
    }
  }
  
}