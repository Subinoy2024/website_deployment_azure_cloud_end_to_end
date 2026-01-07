variable "pip" {
    type=map(object({
name=string
resource_group_name=string
location=string
    }))
}