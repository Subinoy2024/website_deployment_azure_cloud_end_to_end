variable "lb"{
    type=map(object({
        name=string
        location=string
        resource_group_name=string
        forntipname=string
        public_ip_address_id=string
    }))
}