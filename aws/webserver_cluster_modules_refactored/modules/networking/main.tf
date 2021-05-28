terraform {
  required_version = ">= 0.12"
}

locals {
  http_port    = 80
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
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
