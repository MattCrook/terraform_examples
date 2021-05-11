variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-stores/mysql/terraform.tfstate"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "cluster_name" {
    description = "The name to use for all the cluster resources"
    type        = string
    default     = "flask-app-cluster"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 10
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}

# To allow users to specify custom tags
# (Tags set in the production env for examples..)
variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

# Boolean input variable that we can use to specify wheather the module should enable auto-scaling
# Way to conditionally create auto-scaling for some users but not for others.
variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}

# Commented out for now, but can use with the 2 various user-data scipts to allow the user to select which one to use.
# Implemented with if/else statement in data.tf
// variable "enable_new_user_data" {
//   description = "If set to true, use the new (short) User Data script"
//   type        = bool
// }

# For zero-downtime depoyment. In the real world, exposing the AMI as an input varible would be all you need, as
# actual code would be defined in the AMI.
# However in this project, the AMI is just a vanilla Ubuntu image and the code is actually the user-data script.
variable "ami" {
  description = "The AMI to run in the cluster"
  default     = "ami-0c55b159cbfafe1f0"
  type        = string
}

# Additional variable to control the text the user data script from its one-liner HTTP server.
variable "server_text" {
  description = "The text the web server should return"
  default     = "Hello, Terraform"
  type        = string
}
