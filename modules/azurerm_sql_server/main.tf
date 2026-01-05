resource "azurerm_mssql_server" "sql" {
    for_each=var.sqlserver
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = "12.0"
  administrator_login          = each.value.vmusername
  administrator_login_password = each.value.vmpassword
  minimum_tls_version          = "1.2"
}
