resource "azurerm_lb_probe" "prob" {
  for_each = var.prob

  name                = each.value.name
  protocol            = each.value.protocol
  port                = each.value.port
  loadbalancer_id     = each.value.loadbalancer_id
  interval_in_seconds = each.value.interval_in_seconds
}