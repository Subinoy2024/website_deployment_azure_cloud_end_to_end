variable "rgname" {
    type=map(object({
        name=string
        location=string
        
    }))
}
