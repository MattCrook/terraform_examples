# Kubernetes Cluster Project

This project provisions all that is needed for a Kubernetes cluster in GKE. In addition to the cluster itself, additional resources are created such as a new project, service accounts, and various IAM roles and bindings. Full list of resources can be found below.

## Environments

There are two environments that are included in this project:

* Stage (staging)
* Prod (production)

## File Structure

* **Live**
  * *Global* - global resources that will be used in all environments. For example, the Cloud Storage Bucket to be used as backend and store for the terraform remote state.
  * *Stage* - all resources and child modules needed to provision the staging environment.
  * *Prod* - all resources and child modules needed to provision the production environment.
* **Modules**
  * *Cluster* - module for creating a Kubernetes cluster, with it's node pool(s) and node(s).
  * *Project* - module for creating a new GCP project.
  * *Service Account* - module for creating a service account.

## Resources

### Cluster

* `google_container_cluster` - Manages a Google Kubernetes Engine (GKE) cluster.
* `google_container_node_pool` - Manages a node pool in a Google Kubernetes Engine (GKE) cluster separately from the cluster control plane.

### Project

* `google_project` - Allows creation and management of a Google Cloud Platform project. Projects created with this resource must be associated with an Organization.
* `google_project_service` - Allows management of a single API service for an existing Google Cloud Platform project.

### Service Account

* `google_service_account` - Allows management of a Google Cloud service account.
* `google_service_account_iam_binding` - When managing IAM roles, you can treat a service account either as a resource or as an identity. This resource is to add iam policy bindings to a service account resource, such as allowing the members to run operations as or modify the service account.
