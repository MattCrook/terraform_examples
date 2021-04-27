terraform {
  required_version = ">= 0.12"
}


locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}


# To use ASG (Auto Scaling Group) replace the "aws_instance" with the following.
# ASG takes care of launching a cluster or EC2 instances, monitoring health, replacing failed instances, and ajusting size of cluster in response to load.
resource "aws_launch_configuration" "my_instance" {
    image_id               = data.aws_ami.ubuntu.id
    instance_type          = var.instance_type
    security_groups        = [aws_security_group.instance.id]
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
    launch_configuration = aws_launch_configuration.my_instance.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids
    target_group_arns = [aws_lb_target_group.asg.arn]

    # Defualt health_check type is "EC2". Minimal health check that considers an instance unhealthy only if the AWS hypervisor says
    # the VM instance is completely down or unreachable.
    # The ELB health check is more robust bc it instructs the ASG to use the target group's health check.
    health_check_type = "ELB"

    min_size = var.min_size
    max_size = var.max_size

    tag {
        key                 = "Name"
        value               = var.cluster_name
        propagate_at_launch = true
    }
}

# By defult AWS does not allow incoming and outgoing traffic on EC2 instance.
# To allow, must create a security group
# Specfies that the group allows incoming TCP requests on port 8080 from CIDR block 0.0.0.0/0.
resource "aws_security_group" "instance" {
    name = "${var.cluster_name}-instance"

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }
}


resource "aws_lb" "example_load_balancer" {
    name               = "${var.cluster_name}-lb"
    load_balancer_type = "application"
    subnets            = data.aws_subnet_ids.default.ids
    # Tell this resource to use security group "alb" defined below
    security_groups     = [aws_security_group.alb.id]
}


# This listener configures the ALB to listen on port 80, use HTTP protocol and send a simple 404 page as defaul response for requests
# that didnt match the lister rules.
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example_load_balancer.arn
    port              = local.http_port
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
    name = "${var.cluster_name}-alb"

    # Allow inbound HTTP requests
    ingress {
        from_port   = local.http_port
        to_port     = local.http_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }
}

# Separate inline blocks to separate resources - to prevent routing rules to overwrite one another.
resource "aws_security_group" "allow_all_outbound" {
    name = "${var.cluster_name}-alb"
    # Allow all outbound requets
    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = local.all_ips
    }
}

# Target Group for ASG
# This target group with health check the instances by periodically sending and HTTP
# request to each instance and will consider them "healthy" only if the insances response matches the configured "matcher".
resource "aws_lb_target_group" "asg" {
    name        = var.cluster_name
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
