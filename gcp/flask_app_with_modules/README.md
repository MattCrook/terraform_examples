# Flask App

This project is a set up of a [Managed Instance Group (MIG)](https://cloud.google.com/compute/docs/instance-groups#managed_instance_groups) that starts a very simple Flask server.

## Resources

### Global

* `google_storage_bucket` - GCS bucket to store the state. Will use "gcs" as backend which is this bucket.
* `google_project_service` - Enabling a Google service / API with Terraform. Loops through (for_each) extra_api_setnlocal which checks if enable_apis is true, then references the var extra_apis which is list (array) of extra gcp api's to enable for a resource/ service account etc...
* `google_service_account` - Creates a service account for the Google cloud storage to run on, and this account can now be given permissions to what resources it can access.
* `google_service_account_key` - To create a key for the service account which allows the use of a service account outside of Google Cloud.

### Modules

* `google_service_account_iam_binding` - When managing IAM roles, you can treat a service account either as a resource or as an identity. This resource is to add iam policy bindings to a service account resource, such as allowing the members to run operations as or modify the service account.
* `google_compute_autoscaler` - Represents an Autoscaler resource. Autoscalers allow you to automatically scale virtual machine instances in managed instance groups according to an autoscaling policy that you define. Using this to create/manage a cluster of VM's instead of creating a single instance.
* `google_compute_instance_template` - Manages a VM instance template resource within GCE. To use "google_compute_autoscaler" use this to launch a cluster of VM's instead of creating a single VM. Equivalent to `launch configuration` resource in AWS. Takes care of launching a cluster of instances, monitoring health, replacing failed instances, and adjusting size of cluster in response to load.
* `google_compute_health_check` - Auto-healing health check set on configured interval to check health of instance group VM's. Determine whether instances are responsive and able to do work.
* `google_compute_instance_group_manager` - Creates and manages pools of homogeneous Compute Engine virtual machine instances from a common instance template.
* `google_compute_resource_policy` - resource policy used in `google_compute_instance_template`.

### Stage

#### Data-store/ cloudsql

* `google_sql_database_instance` - Creates a new Google SQL Database Instance (Currently configured for PostgreSql).

#### Services/Webserver-cluster

 * `flask_app` - Child module that uses the module defined in */modules/services/webserver-cluster*.
 * `google_compute_network` - Manages a VPC network or legacy network resource on GCP. ***auto-create-subnetworks*** - When set to true, the network is created in "auto subnet mode" and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in "custom subnet mode" so the user can explicitly connect subnetwork resources.
 * `google_compute_firewall` - Google Cloud allows for opening ports to traffic via firewall policies, which can also be managed in Terraform configuration. You can now point the browser to the instance's IP address and port 5000 and see the server running.
 * `google_compute_firewall` - Firewall to allow SSH traffic into the created `google_compute_network`, and targets the service account created and tied to the flask_app.
