variable "bshost"{
    type=map(object({
        name=string
        location=string
        resource_group_name=string
        nicname=string
        subnet_id=string
        public_ip_address_id=string
    }))
}