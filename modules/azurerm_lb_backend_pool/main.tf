

resource "azurerm_lb_backend_address_pool" "this" {
  for_each = var.backendpool

  name            = each.value.name
  loadbalancer_id = each.value.loadbalancer_id
}

