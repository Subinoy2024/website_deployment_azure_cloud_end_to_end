# output "rg"{
#     value=azurerm_resource_group.rg_name
# }

output "rg"{
    value={
        for k,v in azurerm_resource_group.rg_name :
        k=> v.name
    }
}