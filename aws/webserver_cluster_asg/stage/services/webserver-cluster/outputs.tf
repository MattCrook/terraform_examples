output "public_ip" {
    value       = aws_instance.my_instance.public_ip
    description = "The pubic IP address of the web server"
}

output "alb_dns_name" {
    value       = aws_lb.example_load_balancer.alb_dns_name
    description = "The domain name of the load balancer"
}
