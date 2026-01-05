variable "sqldatabase"{
    type=map(object({
        dbname=string
        server_id=string
        collation=string
        license_type=string
        
    }))
}

variable "sqlconnect"{
    type=map(object({
        rule_name=string
        server_id=string
        start_ip_address=string
        end_ip_address=string
    }))
}
