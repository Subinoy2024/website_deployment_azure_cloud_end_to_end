resource "azurerm_network_interface" "nic"{
    for_each=var.vms
    name=each.value.name
    location=each.value.location
    resource_group_name=each.value.resource_group_name

    ip_configuration{
        name="internal"
        subnet_id=each.value.subnet_id
        private_ip_address_allocation = "Dynamic"
            }
}
resource "azurerm_linux_virtual_machine" "vm"{
    for_each=var.vms
    name=each.value.vmname
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    size=each.value.size
    admin_username = each.value.vmusername
    admin_password =each.value.vmpassword
    disable_password_authentication = false
    network_interface_ids = [
        azurerm_network_interface.nic[each.key].id
    ]
    os_disk {
        caching = each.value.caching
        storage_account_type=each.value.storage_account_type
    }
    source_image_reference {
    publisher = each.value.publisher
    offer     =each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }

}