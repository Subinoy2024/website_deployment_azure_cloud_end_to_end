resource "azurerm_network_security_group" "nsg" {
    for_each=var.nsg
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "security_rule" {
    for_each=var.security_rule 
    content {
    name                       = security_rule.value.rule_name
    priority                   = security_rule.value.priority
    direction                  = security_rule.value.direction
    access                     = security_rule.value.access
    protocol                   = security_rule.value.protocol
    source_port_range          = security_rule.value.source_port_range
    destination_port_range     = security_rule.value.destination_port_range
    source_address_prefix      = security_rule.value.source_address_prefix
    destination_address_prefix = security_rule.value.destination_address_prefix
  }
}
}


resource "azurerm_subnet_network_security_group_association" "nsg_association"{
  for_each=var.nsg_asso
  subnet_id                 = each.value.subnet_id
  network_security_group_id = each.value.network_security_group_id
}
