# Configures the web-server cluster code to read the state file from the S3 bucket and folder
# where the database stores it's state.
# Here in the webserver-cluster to give access for the webservers to read the data from the S3 bucket and folder (state file) of the mysql db where the mysql db stores its state.
# Important to understand that data returned by "terraform_remote_state" is read-only. Nothing we do in the 
# webderver-cluster TF code can modify that state.
data "terraform_remote_state" "db" {
    backend = "s3"

    config = {
        bucket = var.db_remote_state_bucket
        key    = var.db_remote_state_key
        region = "us-east-2"
    }
}


data "aws_vpc" "default" {
    # Directs TF to look up the Default VPC in your AWS account.
    default = true
}


# Look up the subnets within your VPC.
data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}


# With this setup Terraform generates a unique name for your Launch Configuration and
# can then update the AutoScaling Group without conflict before destroying the previous Launch Configuration.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# template_file data source is used to ensure dynamic variables are available before the template is read or rendered.
# Grabbing reference to vars here, in the TF code, to inject into file where they are used, ensuring they are available.
# has 2 arguments, template, which is a string to render,
# and vars, which is a map of variables to make available while rendering.
# It has one output called rendered, which is the result of rendering template.
# This sets template parameter to the contents of user_data.sh script and the vars parameter to the three vars
# the script needs.

// data "template_file" "user_data" {
//   template = file("user_data.sh")

//  # These variables go into the script as ${db_address} etc...
//   vars = {
//     server_port = var.server_port
//     db_address  = data.terraform_remote_state.db.outputs.address
//     db_port     = data.terraform_remote_state.db.outputs.port
//   }
// }

# Need a path relative to the module itself
# Use count as makeshift if/else statement...if var.enable_new_user_data is false use the user-data, if true use the user-data-short.
data "template_file" "user_data" {
  count = var.enable_new_user_data ? 0 : 1

  template = file("${path.module}/user-data.sh")

 # These variables go into the script as ${db_address} etc...
  vars = {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }
}

# To use the new user-data script, we need a new template_file data source. 
# We want to allow some of our webserver-clusters to use this alternative, shorter script. 
data "template_file" "user_data_short" {
  count = var.enable_new_user_data ? 1 : 0

  template = file("${path.module}/user-data-short.sh")

 # These variables go into the script as ${db_address} etc...
  vars = {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }
}
