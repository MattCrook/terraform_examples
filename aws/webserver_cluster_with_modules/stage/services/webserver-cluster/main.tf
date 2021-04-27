terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-2"
}

# Providing a backend for the web-server cluster to use S3 as the backend.
terraform {
    backend "s3" {
        bucket         = "tf-up-and-running-state-mc"
        key            = "stage/services/terraform.tfstate"
        region         = "us-east-2"
        dynamodb_table = "tf-up-and-running-locks"
        encrypt        = true
    }
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  # source = "github.com/MattCrook/terraform-examples//code/terraform/04-terraform-module/module-example/modules/services/webserver-cluster?ref=v0.1.0"
  # SSH URL  git@github.com:MattCrook/terraform-examples.git

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 10
}

# Now that we have split up the the ingress and egress security group rules (modules/services/webserver-cluster & outputs), we can add custom rules from outside the module.
# For example, if we had a staging env, and needed to expose an extra port just for testing.
# Add this rule to do that
resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
