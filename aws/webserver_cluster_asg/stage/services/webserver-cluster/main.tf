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

# Created in global/s3/main.tf - Creating the S3 bucket to store the state files in.
# resource "aws_s3_bucket" "tf_state" {
#     bucket = "tf-up-and-running-state-mc"

#     lifecycle {
#         prevent_destroy = true
#     }

#     versioning {
#         enabled = true
#     }

#     server_side_encryption_configuration {
#         rule {
#             apply_server_side_encryption_by_default {
#                 sse_algorithm = "AES256"
#             }
#         }
#     }
# }

# DynamoBD tabe is AWS's distributed key value store, used for locking.
# Supports strongy conistant reads and conditional writes.  Need this to ensure you have a distributed lock system.
# Created in global/s3/main.tf
// resource "aws_dynamodb_table" "terraform_locks" {
//     name            = "tf-up-and-running-locks"
//     billing_mode    = "PAY_PER_REQUEST"
//     hash_key        = "LockID"

//     attribute {
//         name = "LockID"
//         type = "S"
//     }
// }




# To use ASG (Auto Scaling Group) replace the "aws_instance" with the following.
# ASG takes care of launching a cluster or EC2 instances, monitoring health, replacing failed instances, and ajusting size of cluster in response to load.
resource "aws_launch_configuration" "my_instance" {
    # ami                  = "ami-0c55b159cbfafe1f0"
    image_id               = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro"
    security_groups        = [aws_security_group.instance.id]

    # Updated user_data parameter to point to the rendered output attribute of the template_file data source.
    user_data              = data.template_file.user_data.rendered

    # Required when using a launch configuration with auto scaling group.
    # When true, TF will invert order in which it replaces recourses,
    # creating the replacement first (including updating any references that were pointing at old to point a new)
    # and then delete old resource.
    lifecycle {
        create_before_destroy = true
    }
}



resource "aws_autoscaling_group" "my_instance_asg" {
    # Launch configurtions are immuatable. So if you change any parameter of your launch config TF will try to replace it.
    # Normally when replacing a resource, TF deletes it.
    # But bc the ASG now has a reference to the old resource, TF won't be able to delete it.
    launch_configuration = aws_launch_configuration.my_instance.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    # Pointing at new target group...defined below as "asg".
    target_group_arns = [aws_lb_target_group.asg.arn]

    # Defualt health_check type is "EC2". Minimal health check that considers an instance unhealthy only if the AWS hypervisor says
    # the VM instance is completely down or unreachable.
    # The ELB health check is more robust bc it instructs the ASG to use the target group's health check.
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    tag {
        key                 = "Name"
        value               = "AWS-terraform-asg-example"
        propagate_at_launch = true
    }
}

# By defult AWS does not allow incoming and outgoing traffic on EC2 instance.
# To allow, must create a security group
# Specfies that the group allows incoming TCP requests on port 8080 from CIDR block 0.0.0.0/0.
# Use the id  attribute exported from this resource up in the aws_instance resource/ or aws_launch_configuration below.
resource "aws_security_group" "instance" {
    name = var.instance_security_group_name

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Aws has 3 load balancers
# Application Load Balancer (ALB) - best for HTTP and HTTPS traffic, operates at layer 7 (application layer)
# Network Load Balancer(NLB) - best for TCP, UDP, and TLS traffic, operates at layer 4 (transport layer)
# CLassic Load Balancer(CLB) - handles all, older an fewer features.
resource "aws_lb" "example_load_balancer" {
    name               = var.alb_name
    load_balancer_type = "application"
    subnets            = data.aws_subnet_ids.default.ids
    # Tell this resource to use security group "alb" defined below
    security_groups     = [aws_security_group.alb.id]
}

# Next step is to define a listener for this ALB
# This listener configures the ALB to listen on port 80, use HTTP protocol and send a simple 404 page as defaul response for requests
# that didnt match the lister rules.
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example_load_balancer.arn
    port              = 80
    protocol          = "HTTP"

    # By default, return a simple 404 page
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code  = 404
        }
    }
}

# Create new security group for alb that should allow incoming requests on port 80
# So that you can access the load balancer over HTTP, and outgoing requests on all ports so
# that the load balancer can perform health checks.
resource "aws_security_group" "alb" {
    name = var.alb_security_group_name

    # Allow inbound HTTP requests
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all outbound requets
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

# Target Group for ASG
# This target group with health check the instances by periodically sending and HTTP
# request to each instance and will consider them "healthy" only if the insances response matches the configured "matcher".
resource "aws_lb_target_group" "asg" {
    name        = "terraform-asg-example"
    port        = var.server_port
    protocol    = "HTTP"
    vpc_id      = data.aws_vpc.default.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = 200
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

# Tie things together with adding a listener rule hat sends requests that match any path to the target group that contains our ASG(Auto Scaling Group)
resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority     = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.asg.arn
    }
}
