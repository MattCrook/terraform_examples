# Webserver Cluster Refactored

This project builds off of, and is similar to the [webserver_cluster_with_modules](../webserver_cluster_with_modules) project, but adds enhancements like further refactoring of the organization of the code, modules, and resources, by breaking up and grouping each module by it's use case; as well as the addition of an examples directory for easy visibility and portability in the case of different teams using these modules, to provide examples of how each module should be used.

## Modules

The modules are broken out into 4 individual modules, each encapsulating its own resources specific to that module.

### Cluster

Module for creating an ASG Rolling Deploy, through an Auto-Scaling Group and Launch Configuration.

* `aws_launch_configuration` - An instance configuration template that an Auto Scaling group uses to launch EC2 instances.
* `aws_autoscaling_group` - Collection of Amazon EC2 instances that are treated as a logical grouping for the purposes of automatic scaling and management.
* `aws_autoscaling_schedule` - auto scaler schedule to scale up during business hours.
* `aws_autoscaling_schedule` - auto scaler schedule to scale down during evenings.
* `aws_security_group` - Specifies that the group allows incoming TCP requests on port 8080 from CIDR block 0.0.0.0/0. (By defult AWS does not allow incoming and outgoing traffic on EC2 instance).
* `aws_security_group_rule` - Allows to add custom rules in staging env, to expose an extra port just for testing).
* `aws_cloudwatch_metric_alarm` - Cloudwatch alarm that will notify you via a variety of mechanisms if a specific metric exceeds a predefined threshold.
* `aws_cloudwatch_metric_alarm` - Cloudwatch alarm that will go off if your CPU credits are low - meaning the webserver-cluster is almost out of CPU credits.

### Data-stores

Module for creating a RDS instance (MySQL Database)

* `aws_db_instance` - mysql database (RDS instance)

### Networking

Module for handling network traffic, creates a Load Balancer with it's corresponding security group and listener rules.

* `aws_lb` - AWS Load Balancer
* `aws_lb_listener` - Configures the ALB to listen on port 80, use HTTP protocol and send a simple 404 page as default response for requests that didn't match the listener rules.
* `aws_lb_listener_rule` - Ties things together with adding a listener rule that sends requests that match any path to the target group that contains our ASG(Auto Scaling Group).

### Services

Module for creating the webserver cluster. Uses the modules from `Cluster` and `Networking`, to create all specified resources needed and tied to create and manage a cluster of EC2 instances running the webserver application.

* `aws_lb_target_group` - Target Group for ASG. This target group will health check the instances by periodically sending and HTTP request to each instance and will consider them "healthy" only if the instance's response matches the configured "matcher".
* `aws_lb_listener_rule` - Ties things together with adding a listener rule that sends requests that match any path to the target group that contains our ASG(Auto Scaling Group).


## Environments

* Stage (staging)
* Prod (production)

## Further Resources

### live/ global

Global resources that are used. Creates a DynamoDB table to manage state locking through a distributed locking system, as well as an Amazon S3 bucket to serve as the *remote backend* to load and store the Terraform State file.

* `aws_s3_bucket` - S3 Bucket to store state files. Used as backend to share state
* `aws_dynamodb_table` - Amazon's key-value and document NoSQL database
* `aws_iam_user` - Provides an IAM user
* `aws_iam_policy` - full access
* `aws_iam_policy` - read only
* `aws_iam_user_policy_attachment` - full access
* `aws_iam_user_policy_attachment` - read only

### User-Data Script

Once all infrastructure has been provisioned and deployed, you can open up the ALB URL in your browser to view that the text in the script has rendered. 
