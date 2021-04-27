data "terraform_remote_state" "db" {
    backend = "gcs"

    config = {
        bucket = "tf-up-and-running-state-mc"
        prefix = "stage/data-store/cloudsql"
    }
}

// data "google_compute_network" "default" {
//   name = "default-network"
// }


// data "aws_vpc" "default" {
//     # Directs TF to look up the Default VPC in your GCP account.
//     default = true
// }


// # Look up the subnets within your VPC.
// data "aws_subnet_ids" "default" {
//     vpc_id = data.aws_vpc.default.id
// }
