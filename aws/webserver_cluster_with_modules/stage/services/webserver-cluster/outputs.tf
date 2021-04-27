# Exposing the DNS name of the AlB, so we know what URL to test when the cluster is deployed.
# "Passing through" this output from modules/services/webserver-cluster
output "alb_dns_name" {
    value       = module.webserver_cluster.alb_dns_name
    description = "The domain name of the load balancer"
}
