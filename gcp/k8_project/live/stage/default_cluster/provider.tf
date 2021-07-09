provider "kubernetes" {
  load_config_file = "false"

  host     = module.default_cluster.endpoint
  username = var.username
  password = var.password

  client_certificate     = module.default_cluster.client_certificate
  client_key             = module.default_cluster.client_key
  cluster_ca_certificate = module.default_cluster.certificate
}
