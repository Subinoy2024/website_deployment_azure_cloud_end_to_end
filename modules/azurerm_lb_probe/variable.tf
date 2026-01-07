variable "prob"{
    type=map(object({
    name=string
    protocol=string
    port=number
    loadbalancer_id=string  
    interval_in_seconds=string
    }))
}