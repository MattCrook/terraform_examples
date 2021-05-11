data "terraform_remote_state" "db" {
    backend = "gcs"

    config = {
        bucket = "tf-up-and-running-state-mc"
        prefix = "stage/data-store/cloudsql"
    }
}

# Use this data source to retrieve default service account for this project
data "google_compute_default_service_account" "default" {
}

# get a network by its name
# Directs TF to look up the Default VPC in your GCP account.
data "google_compute_network" "flask-app-vpc-network" {
    name = "vpc-network"
}

data "google_compute_network" "default" {
    name = "default-network"
}
# In addition to the arguments listed above, the following attributes are exported:
# id - an identifier for the resource with format projects/{{project}}/global/networks/{{name}}
# description - Description of this network.
# gateway_ipv4 - The IP address of the gateway.
# subnetworks_self_links - the list of subnetworks which belong to the network
# self_link - The URI of the resource.



// data "aws_vpc" "default" {
//     # Directs TF to look up the Default VPC in your GCP account.
//     default = true
// }


// # Look up the subnets within your VPC.
// data "aws_subnet_ids" "default" {
//     vpc_id = data.aws_vpc.default.id
// }
