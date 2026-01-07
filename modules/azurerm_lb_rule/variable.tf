variable"rulelb"{
    type=map(object({
  loadbalancer_id                = string
  name                           = string
  protocol                       = string
  frontend_port                  = number
  backend_port                   = number
  frontend_ip_configuration_name = string
    }))
}