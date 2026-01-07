variable "backendpool"{
    type=map(object({
        name=string
        loadbalancer_id=string
    }))
}