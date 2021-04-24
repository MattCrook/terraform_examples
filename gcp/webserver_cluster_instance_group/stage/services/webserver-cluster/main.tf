terraform {
  required_version = ">= 0.12"
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("credentials.json")
}

# To use a module, basicaly like "calling a function"
# Using the module defined in /modules/services/webserver-cluster
# Really didn't have to fill in these vars, the use of a module is so that we can use
# the same logic, but pass in different values.
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key
  instance_type          = "t2.micro"
  min_replicas           = var.min_size
  max_replicas           = var.max_size
}






resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
