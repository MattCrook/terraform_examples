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

## Modules

### Cluster

* `google_container_cluster` - Manages a Google Kubernetes Engine (GKE) cluster.
* `google_container_node_pool` - Manages a node pool in a Google Kubernetes Engine (GKE) cluster separately from the cluster control plane.

### Project

* `google_project` - Allows creation and management of a Google Cloud Platform project. Projects created with this resource must be associated with an Organization.
* `google_project_service` - Allows management of a single API service for an existing Google Cloud Platform project.

### Service Account

* `google_service_account` - Allows management of a Google Cloud service account.
* `google_service_account_iam_binding` - When managing IAM roles, you can treat a service account either as a resource or as an identity. This resource is to add iam policy bindings to a service account resource, such as allowing the members to run operations as or modify the service account.

## App

To deploy and view the Node.js/Express app, first provision the necessary infrastructure in `/live/stage/default_cluster` by running:

* `terraform init`
* `terraform apply`

Once the cluster is built, connect to it, and from the `/live/stage/app` directory apply each of the Kubernetes config files.

| Note: Not using Helm here because there are only three files. Just doing the basic way using the `kubectl` tool to create or apply the files and send them to the Kubernetes API directly. |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

* `kubectl apply -f webserver-app-deployment.yaml`
* `kubectl apply -f webserver-nodeport.yaml`
* `kubectl apply -f ingress.yaml`


##### You will also need to install and deploy an Ingress Controller to use an Ingress. I made use of the Nginx Ingress Controller:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.47.0/deploy/static/provider/cloud/deploy.yaml
```


Running these commands will create:

* **A Deployment** - that pulls a Docker image from my DockerHub, and runs the container on port 8080.
* **A Nodeport Service** - Which the Ingress will forward appropriate requests with the appropriate host to, to access the pods housing the Docker container which contains the app. (Nodeport is required by GKE for an Ingress to point to, check your cloud provider for the necessary configuration on using an Ingress.)
* **An Ingress and Ingress Controller** - Defines the path and rules for requests and exposes multiple services through a single IP address.
  * When a client sends a HTTP request to the Ingress, the host and path in the request determine which service the request is forwarded to. An Ingress only requires one public IP address, even when providing access to dozens of services, this is different than a **LoadBalancer** in that each LoadBalancer service requires its own load balancer with its own public IP address.

##### To view the application, you can copy/paste into your browser:

```
Get the IP of the Ingress:
- kubectl get ingress -n default

Then, in your browser:
- hhtp://<INGRESS_IP>:8080
```
