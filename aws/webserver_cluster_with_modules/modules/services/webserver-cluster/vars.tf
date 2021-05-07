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

// variable "alb_name" {
//   description = "The name of the ALB"
//   type        = string
//   default     = "terraform-asg-example"
// }

// variable "instance_security_group_name" {
//   description = "The name of the security group for the EC2 Instances"
//   type        = string
//   default     = "terraform-example-instance"
// }

// variable "alb_security_group_name" {
//   description = "The name of the security group for the ALB"
//   type        = string
//   default     = "terraform-example-alb"
// }

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
