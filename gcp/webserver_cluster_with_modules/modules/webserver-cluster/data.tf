data "terraform_remote_state" "db" {
  backend = "gcs"
  config {
    bucket  = "${var.db_remote_state_bucket}"
    prefix  = "${var.db_remote_state_key}"
  }
}

// data "terraform_remote_state" "db" {
//     backend = "gcs"

//     config = {
//         bucket = var.db_remote_state_bucket
//         prefix = stage/data-store/cloudsql
//     }
// }

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    # The Google Cloud MySQL DB port is stored in the state file
    db_port     = "3306"
  }
}
