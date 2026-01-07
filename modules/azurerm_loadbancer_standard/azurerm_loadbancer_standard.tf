
resource "azurerm_lb" "lb" {
  for_each=var.lb
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = each.value.forntipname
    public_ip_address_id = each.value.public_ip_address_id
  }
}