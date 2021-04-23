// output "public_ip" {
//     value       = aws_instance.my_instance.public_ip
//     description = "The pubic IP address of the web server"
// }

output "alb_dns_name" {
    value       = aws_lb.example_load_balancer.dns_name
    description = "The domain name of the load balancer"
}


output "security_group_instance_egress" {
    value       = aws_security_group.instance.egress
    description = "The domain name of the load balancer"
}

// output "example_load_balancer_Ipv6" {
//     value       = "aws_lb.example_load_balancer.subnet_mapping.ipv6_address"
//     description = "IPv6 address of the load balancer"
// }


output "ami_id"{
    value       = aws_launch_configuration.my_instance.image_id
    description = "AMI image_id of the virtual machine"
}
