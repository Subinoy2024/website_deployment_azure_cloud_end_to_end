
module "rg1" {
  source = "../../modules/azurerm_resource_group"
  #for_each = var.rgname
  rgname = {
    rg1 = {
      name     = "ind_devops"
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
      name                = "vnet001"
      location            = "central india"
      resource_group_name = "ind_devops"
      address_space       = ["10.0.0.0/22"]
    }
  }

}

module "subnet" {
  source     = "../../modules/azurerm_subnet"
  depends_on = [module.rg1, module.vnet]
  ##for_each = var.subnet
  subnet = {
    s1 = {
      name                 = "subnet01"
      resource_group_name  = "ind_devops"
      virtual_network_name = "vnet001"
      address_prefixes     = ["10.0.1.0/24"]
    }
  }
}

module "nsg" {
  source = "../../modules/azurerm_network_security_group"
  nsg = {
    nsg1 = {
      name                = "nsg01"
      resource_group_name = "ind_devops"
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
    nsg_asso1={
      subnet_id=module.subnet.subnet["s1"]
      network_security_group_id=module.nsg.nsg_id["nsg1"]
    }
  }
}

module "vm" {
  source     = "../../modules/azurerm_virtual_machine"
  depends_on = [module.rg1, module.subnet, module.vnet]
  #for_each = var.vms
  vms = {
    vm1 = {
      name                = "nic01"
      location            = "central india"
      resource_group_name = "ind_devops"
      subnet_id           = module.subnet.subnet["s1"]

      vmname               = "Forntend01"
      size                 = "Standard_B1s"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      publisher            = "dcassociatesgroupinc"
      offer                = "ubuntu-server-25-04"
      sku                  = "ubuntu-server-25-04"
      version              = "latest"

      vmusername = data.azurerm_key_vault_secret.vm_username.value
      vmpassword = data.azurerm_key_vault_secret.vm_password.value
    }
    vm2 = {
      name                = "nic02"
      location            = "central india"
      resource_group_name = "ind_devops"
      subnet_id           = module.subnet.subnet["s1"]

      vmname               = "Backendvm02"
      size                 = "Standard_B1s"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      publisher            = "dcassociatesgroupinc"
      offer                = "ubuntu-server-25-04"
      sku                  = "ubuntu-server-25-04"
      version              = "latest"

      vmusername = data.azurerm_key_vault_secret.vm_username.value
      vmpassword = data.azurerm_key_vault_secret.vm_password.value
    }
  }
}