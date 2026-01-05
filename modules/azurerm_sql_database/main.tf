
resource "azurerm_mssql_database" "db" {
  for_each=var.sqldatabase
  name         = each.value.dbname
  server_id    = each.value.server_id
  collation    = each.value.collation
  license_type = each.value.license_type
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
}

resource "azurerm_mssql_firewall_rule" "allow_ip" {
    for_each=var.sqlconnect
  name             = each.value.rule_name
  server_id        = each.value.server_id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}