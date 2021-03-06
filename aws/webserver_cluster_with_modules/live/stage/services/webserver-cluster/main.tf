provider "aws" {
  region = "us-east-2"
}

# Providing a backend for the web-server cluster to use S3 as the backend.
// terraform {
//     backend "s3" {
//         bucket         = "tf-up-and-running-state-mc"
//         key            = "stage/services/webserver-cluster/terraform.tfstate"
//         region         = "us-east-2"
//         dynamodb_table = "tf-up-and-running-locks"
//         encrypt        = true
//     }
// }

# When making a change to something in modules/services/webserver-cluster, workflow is:
# normal git workflow (add, commit, push to master)
# Then to cut a new release, git tag -a "v0.0.0" -m "Message..."
# git push --follow-tags -- to push the tagged release to github.
# Then, here on staging change the ref to the new release...while keeping prod the same. Once we are satisfied there are no bugs,
# can update the ref in production.

# However, when locally on own computer, it is best and faster to have the relative file path.
# BEcause you be able to make changes and re run tf plan and apply immedialty, rather than having to commit the code
# and publish a new version each time.

# source = "github.com/MattCrook/terraform-examples//aws/webserver_cluster_with_modules/modules/services/webserver-cluster?ref=v0.0.1"
# SSH URL
# source = "git@github.com:MattCrook/terraform-examples.git"

module "webserver_cluster" {
    source = "../../../../modules/services/webserver-cluster"

    ami         = "ami-0c55b159cbfafe1f0"
    # Changing the server text to something new.
    server_text = "New Server Text"

    cluster_name           = var.cluster_name
    db_remote_state_bucket = var.db_remote_state_bucket
    db_remote_state_key    = var.db_remote_state_key

    instance_type          = "t2.micro"
    min_size               = 2
    max_size               = 10
    enable_autoscaling     = false
    // enable_new_user_data   = true
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

# Setting count to 1 on a resoucre you get one copy of the resouce, settin it to zero the resource is not created at all.
# If var.enable_autoscaling is set to true, then count parameter will be set to 1.
# Because variable is in both and we have separated these resouces by scale up and down, only changing the var from true or false 
# Will either create one of each, or not create either.
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
    count = var.enable_autoscaling ? 1 : 0

    scheduled_action_name = "scale-out-during-business-hours"
    min_size              = 2
    max_size              = 10
    desired_capacity      = 10
    recurrence            = "0 9 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}


resource "aws_autoscaling_schedule" "scale_in_at_night" {
    count = var.enable_autoscaling ? 1 : 0

    scheduled_action_name = "scale-in-at-night"
    min_size              = 2
    max_size              = 10
    desired_capacity      = 2
    recurrence            = "0 17 * * *"

    autoscaling_group_name = module.webserver_cluster.asg_name
}
