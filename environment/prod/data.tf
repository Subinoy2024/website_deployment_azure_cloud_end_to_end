# Get current tenant
data "azurerm_client_config" "current" {}


# Existing Key Vault
data "azurerm_key_vault" "this" {
  name                = "softtechkeyvault"
  resource_group_name = "Glabal_key"
}

# Secrets
data "azurerm_key_vault_secret" "vm_username" {
  name         = "vmusername"
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "vmpassword"
  key_vault_id = data.azurerm_key_vault.this.id
}


