# Exposing the DNS name of the AlB, so we know what URL to test when the cluster is deployed.
# NOTE - "Passing through" this output from modules/services/webserver-cluster
# The idea of passing through is to define outputs in the parent module, (which when you run tf plan in this dir you will not see those outputs)
# But then referencing those outputs and the output name of the parent module when calling it as we are here, 
# to actually output those output vars when running tf plan and apply and so they are available.
output "alb_dns_name" {
    value       = module.webserver_cluster.alb_dns_name
    description = "The domain name of the load balancer"
}

output "security_group_instance_egress" {
    value       = module.webserver_cluster.security_group_instance_egress
    description = "The domain name of the load balancer"
}

output "ami_id"{
    value       = module.webserver_cluster.ami_id
    description = "AMI image_id of the virtual machine"
}

output "asg_name" {
    value       = module.webserver_cluster.asg_name
    description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
    value       = module.webserver_cluster.alb_security_group_id
    description = "The ID of the Security Group attached to the load balancer"
}

output "example_load_balancer_Ipv6" {
    value       = module.webserver-cluster.example_load_balancer_Ipv6
    description = "IPv6 address of the load balancer"
}
