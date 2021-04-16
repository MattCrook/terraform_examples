// Note if a default is not given, if you do not specifiy a port to run on, 
// and run apply, TF will interactivly prompt you to enter a value for server_port
// and show the description of the var.

// terraform plan -var "server_port=8080" or export TF_VAR_server_port=8080
// However providing the default means you will not have to pass the var in when running terraform plan.

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 8080
}
