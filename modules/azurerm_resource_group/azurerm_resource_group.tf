resource "azurerm_resource_group" "rg_name"{
    for_each=var.rgname
    name=each.value.name
    location=each.value .location
}
      


