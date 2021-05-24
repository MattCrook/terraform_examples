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
# Launch Config takes care of launching a cluster or EC2 instances, monitoring health, replacing failed instances, and ajusting size of cluster in response to load.
resource "aws_launch_configuration" "my_instance" {
    # image_id               = data.aws_ami.ubuntu.id
    image_id               = var.ami
    instance_type          = var.instance_type
    security_groups        = [aws_security_group.instance.id]
    # user_data              = data.template_file.user_data.rendered
    user_data              = var.user_data

    # Both template_file data sources are array, because use count parameter. However, can't use array syntax,
    # becuse one might be empty, so use splat sytax - which will always return an array (albeit maybe zero) and check the length of that array.
    # Looking for a length of greater than 0, otherwise evalute the second part of ternary.
    // user_data = (
    //     length(data.template_file.user_data[*]) > 0
    //       ? data.template_file.user-data[0].rendered
    //       : data.template_file.user-data-short[0].rendered
    // )

    # Required when using a launch configuration with auto scaling group.
    # When true, TF will invert order in which it replaces recourses,
    # creating the replacement first (including updating any references that were pointing at old to point a new)
    # and then delete old resource.
    lifecycle {
        create_before_destroy = true
    }
}

# Zero downtime deployment - configure name parameer of the ASG to depend directly on the name of the launch configuration.
# Each time the lauch configuration changes (which it will when you update the AMI or User Data) its name changes, and therefor
# the ASG's name will change, which forces TF to replce the ASG
# Set create_before_destroy to true
# Set min_elb_capacity parameter of the ASG to min_size of the cluster so that TF will wait for at least that many servers from the new ASG to pass
# health checks in the ALB before it will begin destroying the original ASG.
resource "aws_autoscaling_group" "my_instance_asg" {
    name                 = "${var.cluster_name} - ${aws_launch_configuration.my_instance.name}"
    launch_configuration = aws_launch_configuration.my_instance.name
    vpc_zone_identifier  = data.aws_subnet_ids.default.ids
    target_group_arns    = [aws_lb_target_group.asg.arn]

    # Defualt health_check type is "EC2". Minimal health check that considers an instance unhealthy only if the AWS hypervisor says
    # the VM instance is completely down or unreachable.
    # The ELB health check is more robust bc it instructs the ASG to use the target group's health check.
    health_check_type = "ELB"
    min_size          = var.min_size
    max_size          = var.max_size
    min_elb_capacity  = var.min_size

    tag {
        key                 = "Name"
        value               = var.cluster_name
        propagate_at_launch = true
    }

    # Going to dynamically loop over the "custom_tags" var, which is a map, and plug into the key and value the k,v pair from the map.
    # dynamic "tag" - tag is the name var name, for the iteration on var.custom tags, and each iterable is a map so we can get tag.key and tag.value
    // dynamic "tag" {
    //     for_each = var.custom_tags

    //     content {
    //         key                 = tag.key
    //         value               = tag.value
    //         propagate_at_launch = true
    //     }
    // }

    # The nested for expression llops over var.custom_tags, coverts each value to uppercase, and uses a conditional
    # in the for expression to filter out any key set to Name - because the module already sets its own name tag.
    # Can implement arbitrary conditional logic by filtering the values in the for expression.
    dynamic "tag" {
        for_each = {
        for key, value in var.custom_tags:
        key => upper(value)
        if key != "Name"
        }

        content {
        key                 = tag.key
        value               = tag.value
        propagate_at_launch = true
        }
    }
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

# Cloudwatch alarm - notify you via a variety of mechanisms if a specific metric exceeds a predefined threshold.
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
    alarm_name  = "${var.cluster_name}-high-cpu-utilization"
    namespace   = "AWS/EC2"
    metric_name = "CPUUtilization"

    dimensions = {
        AutScalingGroupName = aws_autoscaling_group.my_instance_asg.name
    }

    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 1
    period              = 300
    statistic           = "Average"
    threshold           = 90
    unit                = "Percent"
}

# Cloudwatch alarm that will go off if your CPU credits are low - meaning the webserver-cluster is almost out of CPU credits.
resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
    # cpu credits only apply to txxx instance types.
    # Using the format() funtion to extract just the first character to check if it is "t".
    count = format("%.1s", var.instance_type) == "t" ? 1 : 0

    alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
    namespace   = "AWS/EC2"
    metric_name = "CPUCreditBalance"

    dimensions = {
        AutScalingGroupName = aws_autoscaling_group.my_instance_asg.name
    }

    comparison_operator = "LessThanThreshold"
    evaluation_periods  = 1
    period              = 300
    statistic           = "Minimum"
    threshold           = 10
    unit                = "Count"
}
