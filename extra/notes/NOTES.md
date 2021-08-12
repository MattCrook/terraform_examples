## Notes 

Youtube GKE cluster video:

https://www.youtube.com/watch?v=Vcv6GapxUCI&t=35s

##### Heredoc syntax
```
"here doc" syntax <<EOF

EOF for Multiline strings
```

##### Gcloud common commands
```
gcloud organizations list
gcloud beta billing accounts list
```
##### Setting Terraform Environment Variables For Project
```
export TF_VAR_org_id=YOUR_ORG_ID
export TF_VAR_billing_account=YOUR_BILLING_ACCOUNT_ID
export TF_ADMIN=${USER}-terraform-admin
export TF_CREDS=~/.config/gcloud/${USER}-terraform-admin.json
```

#### Connect Cluster To Local Machine
```
$ gcloud container clusters get-credentials k8-cluster-project-gke-cluster-default --zone us-central1-c --project k8-cluster-project
```

##### List clusters and info (to find info, like zone etc...)
```
gcloud container clusters list
```

##### Create a GCE PersistentDisk. This is Provisioning the storge manually.
```
gcloud compute disks create --size=10GB --zone=us-central1-c mongodb
```

##### Authenticating and OAuth with service account:
```
If you're running Terraform from a GCE instance, default credentials are automatically available. See Creating and Enabling Service Accounts for Instances for more details.
On your computer, you can make your Google identity available by running gcloud auth application-default login.

kubectl config view -o jsonpath='{.users[*].name}'
kubectl config view -o jsonpath='{.users[?(@.name == "gke_k8-cluster-project_us-central1-c_kubia")].user.password}'
kubectl config view -o jsonpath='{.users[?(@.name == gke_k8-cluster-project_us-central1-c_kubia)].user.password}'
kubectl config view -o jsonpath='{.users[?(@.name == "gke_k8-cluster-project_us-central1-c_kubia")].user.password}'
kubectl config view

kubectl get secrets
```

##### Kubernetes Dashboard
```
kubectl proxy http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

kubectl cluster-info

kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml\n

kubectl proxy http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

kubectl proxy http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/\#/login

kubectl describe secrets

kubectl proxy http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/\#/login
```

###### Minikube Addons
```
minikube addons list
minikube addons enable <addon>

minikube kubernetes Dashboard
minikube dashboard
minikube dashboard --url
```

##### Kubectl Commands
```
kubectl get pods --all-namespaces
kubectl get secret -n kubernetes-dashboard -o yaml

kubectl describe pod kubernetes-dashboard-9f9799597-vmdm7 -n kubernetes-dashboard
kubectl cluster-info

kubectl get pods --show-labels
kubectl get jobs
kubectl api-resources -o name
kubectl api-resources --namespaced=true

kubectl get events --sort-by=.metadata.creationTimestamp

kubectl config view -o jsonpath='{.users[*].name}'
kubectl config current-context

kubectl cluster-info
kubectl cluster-info dum
kubectl cluster-info dump
kubectl cluster-info dump > cluster.txt
```
