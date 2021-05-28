# Terraform

This repository consists of a collection of Terraform examples and projects provisioning different types and resources of infrastructure. The projects utilize both GCP, and AWS as cloud providers, and consist of the same projects, but transposed between the two different providers.

## AWS

### Webserver Cluster (Amazon EC2 Auto Scaling Group)

### Resources 

#### Global
* `aws_s3_bucket` - S3 Bucket to store state files. Used as backend to share state
* `aws_dynamodb_table` - Amazon's key-value and document NoSQL database
* `aws_iam_user`
* `aws_iam_policy` - full access
* `aws_iam_policy` - read only
* `aws_iam_user_policy_attachment` - full access
* `aws_iam_user_policy_attachment` - read only


#### Environments
* Stage (staging)
* Prod (production)
#### data-store
* `aws_db_instance` - mysql database (RDS instance)

#### Services/webserver-cluster

* `aws_launch_configuration` - An instance configuration template that an Auto Scaling group uses to launch EC2 instances.
* `aws_autoscaling_group` - Collection of Amazon EC2 instances that are treated as a logical grouping for the purposes of automatic scaling and management.
* `aws_security_group` - Specifies that the group allows incoming TCP requests on port 8080 from CIDR block 0.0.0.0/0. (By defult AWS does not allow incoming and outgoing traffic on EC2 instance).
* `aws_lb` - load balancer
* `aws_lb_listener` - Configures the ALB to listen on port 80, use HTTP protocol and send a simple 404 page as default response for requests that didn't match the lister rules.
* `aws_lb_target_group` - Target Group for ASG. This target group with health check the instances by periodically sending and HTTP request to each instance and will consider them "healthy" only if the instances response matches the configured "matcher".
* `aws_lb_listener_rule` - Ties things together with adding a listener rule that sends requests that match any path to the target group that contains our ASG(Auto Scaling Group).
* `aws_cloudwatch_metric_alarm` - Cloudwatch alarm that will notify you via a variety of mechanisms if a specific metric exceeds a predefined threshold.
* `aws_cloudwatch_metric_alarm` - Cloudwatch alarm that will go off if your CPU credits are low - meaning the webserver-cluster is almost out of CPU credits.

* `aws_security_group` - ingress (rules to allow inbound requests)
* `aws_security_group` - egress (rules to allow outbound requests)
* `aws_security_group_rule` - Allows to add custom rules in staging env, to expose an extra port just for testing).
* `aws_autoscaling_schedule` - auto scaler schedule to scale up during business hours.
* `aws_autoscaling_schedule` - auto scaler schedule to scale down during evenings.


## GCP 

For GCP, there are a couple of different projects. 
* The `webserver_cluster_with_modules` is a direct mirror of the project by the same name in AWS, transposed to what it would look like under a different provider (in this case GCP).
  * To see more, click [here](gcp/flask_app_with_modules/README.md).
* The `flask_app_with_modules` is a stand alone project, that uses Google Compute Engine, and the compute auto-scaler and compute instance group manager to launch and manage a cluster of VMs.
  * To see more, click [here](gcp/webserver_cluster_with_modules/README.md).
* The `k8_project` is another stand alone project, that provisions and manages a Kubernetes cluster in GKE.
  * To see more, click [here](gcp/k8_project/README.md).
