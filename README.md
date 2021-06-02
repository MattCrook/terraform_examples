# Terraform

This repository consists of a collection of Terraform examples and projects provisioning different types and resources of infrastructure. The projects utilize both GCP, and AWS as cloud providers, and consist of the same projects, but transposed between the two different providers.

## AWS

* The `simple_ami_on_EC2` is a simple set up of a single AMI (Amazon Machine Image) with security groups, a load balancer, and load balancer listener.
  * To see more, click [here](aws/simple_ami_on_EC2).
* The `webserver_cluster_asg` consists of an Auto Scaling group that launches a cluster a VMs.
  * To see more, click [here](aws/webserver_cluster_asg).
* The `webserver_cluster_with_modules` builds on the `webserver_cluster_asg` by adding additional resources, as well as creating modules for logical separation of concerns and code portability and reusability.
  * To see more, click [here](aws/webserver_cluster_with_modules).
* The `webserver_cluster_with_modules_refactored` is the finished product with complete refactoring and separation/ creation of modules, as well as added resources, with the addition of examples (best practice for new developers that will be using the modules, to help better understand how the module is supposed to be used) and tests.
  * To see more, click [here](aws/webserver_cluster_modules_refactored).

## GCP

For GCP, there are a couple of different projects.

* The `webserver_cluster_with_modules` is a direct mirror of the project by the same name in AWS, transposed to what it would look like under a different provider (in this case GCP).
  * To see more, click [here](gcp/flask_app_with_modules/README.md).
* The `flask_app_with_modules` is a stand alone project, that uses Google Compute Engine, and the compute auto-scaler and compute instance group manager to launch and manage a cluster of VMs.
  * To see more, click [here](gcp/webserver_cluster_with_modules/README.md).
* The `k8_project` is another stand alone project, that provisions and manages a Kubernetes cluster in GKE.
  * To see more, click [here](gcp/k8_project/README.md).
