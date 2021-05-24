variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-store/mysql/terraform.tfstate"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "cluster_name" {
    description = "The name to use for all the cluster resources"
    type        = string
    default     = "webserver-cluster"
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

# directs the asg-rolling-deploy module to the subnets to deploy into. (Where as webserver-cluster module was hardcoded to deploy into the Default VPC)
variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

# Configures how the asg integrates with load balancers.
# Exposing the load balancer settings as input vars allows you to use the ASG with a wide variety of use cases e.g load balancer, no load balancer, one ALB, multiple NLBs, a etc...
variable "target_group_arns" {
  description = "The ARNs of ELB target groups in which to register Instances"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  default     = "EC2"
}

# Passing the user_data variable through to the aws_launch_configuration.
# Replacing hardcoded User Data script that could only be used to deploy the webserver-cluster app, by taking user-data as an input variable.
variable "user_data" {
  description = "The User Data script to run in each Instance at boot"
  type        = string
  default     = null
}
