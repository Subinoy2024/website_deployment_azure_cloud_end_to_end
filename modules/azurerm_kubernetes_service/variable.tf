variable "aks"{
    type=map(object({
        name=string
        location=string
        resource_group_name=string
        dns_prefix=string
        defaultnodepoolname=string
        node_count=number
        vm_size=string
    }))
}