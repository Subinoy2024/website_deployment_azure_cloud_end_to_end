
output "lb_ids" {
  value = {
    for k, lb in azurerm_lb.lb :
    k => lb.id
  }
}

output "frontend_ip_names" {

  value = {
    for k, lb in azurerm_lb.lb :
    k => lb.frontend_ip_configuration[0].name
  }
}
