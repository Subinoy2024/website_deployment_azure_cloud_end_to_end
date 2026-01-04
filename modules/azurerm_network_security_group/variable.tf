variable "nsg"{
    type=map(object({
    name                       = string
    resource_group_name     = string
    location                   = string

    }))
}
 variable "security_rule"{
    type=map(object({
    rule_name                  = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    }))
 }

 variable "nsg_asso"{
    type=map(object({
        subnet_id=string
        network_security_group_id=string
    }))
 }