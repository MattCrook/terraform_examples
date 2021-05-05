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
  # source = "github.com/MattCrook/terraform_examples/aws/webserver_cluster_with_modules/modules/services/webserver-cluster?ref=v0.1.0"
  # SSH URL  git@github.com:MattCrook/terraform_examples/aws/webserver_cluster_with_modules/modules/services/webserver-cluster.git?ref=v0.1.0

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10

  # Custom tags set, vars in modules/services/websever-cluster
  # Owner specifies the team that owns this ASG
  # DeployedBy tag specifies that this infrustructure was deployed using Terraform, and shoulde not be modified manually.
  custom_tags = {
    Owner      = "team-of-ownership"
    DeployedBy = "terraform
  }
}


# Powerful feature of ASG's is that you can congifure them to increase or decsrease the number of servers you have running in response to load.
# One way is to use a "scheduled action", which can change the size of the cluster a a scheduled time of day.
# "recurrence" parameter uses cron synax...0 9 * * * means 9am everyday. 
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}


resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}
