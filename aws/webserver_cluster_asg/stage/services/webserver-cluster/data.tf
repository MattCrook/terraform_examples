# Configures the web-server cluster code to read the state file from the S3 bucket and folder
# where the database stores it's state.
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


data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }
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
