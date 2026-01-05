variable "sqlserver"{
    type=map(object({
        name=string
        resource_group_name=string
        location=string
        version= string
        vmusername=string
        vmpassword=string

    }))
}
