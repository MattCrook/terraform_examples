output "alb_dns_name" {
  value       = module.app.alb_dns_name
  description = "The domain name of the load balancer"
}


# Passing though these outputs

output "security_group_instance_egress" {
    value       = module.app.security_group_instance_egress
    description = "The domain name of the load balancer"
}

output "ami_id"{
    value       = module.app.ami_id
    description = "AMI image_id of the virtual machine"
}

output "asg_name" {
    value       = module.app.asg_name
    description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
    value       = module.app.alb_security_group_id
    description = "The ID of the Security Group attached to the load balancer"
}
