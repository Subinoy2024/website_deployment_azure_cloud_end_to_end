output "server_id"{
    value = {
      for k,v in azurerm_mssql_server.sql:
        k => v.id
}
}