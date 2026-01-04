variable "vms"{
    type=map(object({
        name=string
        resource_group_name=string
        location=string
        subnet_id=string
        vmname=string
        size=string
        caching=string
        storage_account_type=string
        publisher=string
        offer=string
        sku=string
        version=string
        vmpassword=string
        vmusername=string
        


    }))
}
