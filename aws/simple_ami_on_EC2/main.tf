provider "aws" {
    region = "us-east-2"
}

// AMI is an Amazon Machine Image, to run on the EC2 instance.
// This is a single instance, this would need to be removed if we were planning to use the aws_launch_configuration.
resource "aws_instance" "my_instance" {
    ami                    = "ami-0c55b159cbfafe1f0"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    // Simple bash script that writes to a html file and runs a tool called busybox and serves the file.
    // user_data = <<-EOF
    //             #! /bin/bash
    //             echo "Hello Terraform" > index.html
    //             nohup busybox hhtpd -f -p 8080 &
    //             EOF
    user_data = <<-EOF
            #! /bin/bash
            echo "Hello Terraform" > index.html
            nohup busybox hhtpd -f -p "${var.server_port}" &
            EOF

    // If Doesn't have a name yet, so to add one you can add tags to the aws_instance resource
    tags = {
        Name = "AWS-terraform-example"
    }
}

// By defult AWS does not allow incoming and outgoing traffic on EC2 instance.
// To allow, must create a security group
// Specfies that the group allows incoming TCP requests on port 8080 from CIDR block 0.0.0.0/0.
// Use the id  attribute exported from this resource up in the aws_instance resource.
resource "aws_security_group" "instance" {
    name = "terraform-example-instance"

    ingress {
        // from_port   = 8080
        // to_port     = 8080
        // Or using variable reference:
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}



// To use ASG (Auto Scaling Group) replace the "aws_instance" with the following.
// ASG takes care of launching a cluster or EC2 instances, monitoring health, replacing failed instances, and ajusting size of cluster in response to load.
resource "aws_launch_configuration" "my_instance" {
    ami                    = "ami-0c55b159cbfafe1f0"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]

    user_data = <<-EOF
            #! /bin/bash
            echo "Hello Terraform" > index.html
            nohup busybox hhtpd -f -p "${var.server_port}" &
            EOF

    // Required when using a launch configuration with auto scaling group.
    // When true, TF will invert order in which it replaces recourses,
    // creating the replacement first (including updating any references that were pointing at old to point a new)
    // and then delete old resource.
    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_autoscaling_group" "my_instance_asg" {
    // Launch configurtions are immuatable. So if you change any parameter of your launch config TF will try to replace it.
    // Normally when replacing a resource, TF deletes it.
    // But bc the ASG now has a reference to the old resource, TF won't be able to delete it.
    launch_configuration = aws_launch_configuration.my_instance.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    // Pointing at new target group...defined below as "asg". 
    target_group_arns = [aws_lb_target_group.asg.arn]

    // Defualt health_check type is "EC2". Minimal health check that considers an instance unhealthy only if the AWS hypervisor says
    // the VM instance is completely down or unreachable.
    // The ELB health check is more robust bc it instructs the ASG to use the target group's health check.
    health_check_type = "ELB"

    min_size = 2
    max_size = 10

    tag {
        key                 = "Name"
        value               = "AWS-terraform-asg-example"
        propagate_at_launch = true
    }
}

// Aws has 3 load balancers
// Application Load Balancer (ALB) - best for HTTP and HTTPS traffic, operates at layer 7 (application layer)
// Network Load Balancer(NLB) - best for TCP, UDP, and TLS traffic, operates at layer 4 (transport layer)
// CLassic Load Balancer(CLB) - handles all, older an fewer features.
resource "aws_lb" "example_load_balancer" {
    name               = "terraform-asg-example"
    load_balancer_type = "application"
    subnets            = data.aws_subnet_ids.default.ids
    // Tell this resource to use security group "alb" defined below
    security_group     = [aws_security_group.alb.id]
}

// Next step is to define a listener for this ALB
// This listener configures the ALB to listen on port 80, use HTTP protocol and send a simple 404 page as defaul response for requests
// that didnt match the lister rules.
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.example.around
    port              = 80
    protocol          = "HTTP"

    // By default, return a simple 404 page
    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code  = 404
        }
    }
}

// Create new security group for alb that should allow incoming requests on port 80
// So that you can access the load balancer over HTTP, and outgoing requests on all ports so
// that the load balancer can perform health checks.
resource "aws_security_group" "alb" {
    name = "terreaform-example-alb"

    // Allow inbound HTTP requests
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // Allow all outbound requets
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

// Target Group for ASG
// This target group with health check the instances by periodically sending and HTTP
// request to each instance and will consider them "healthy" only if the insances response matches the configured "matcher".
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

// Tie things together with adding a listener rule hat sends requests that match any path to the target group that contains our ASG(Auto Scaling Group)
recourse "aws_lb_listener_rule" "asg" {
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
