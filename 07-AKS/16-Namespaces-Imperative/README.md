# Kubernetes Namespaces - Imperative using kubectl

## Step-02: Namespaces Generic - Deploy in Dev1 and Dev2
### Create Namespace
```
# List Namespaces
kubectl get ns 

# Craete Namespace
kubectl create namespace <namespace-name>
kubectl create namespace dev1
kubectl create namespace dev2

# List Namespaces
kubectl get ns 
```
### Deploy All k8s Objects to default, dev1 and dev2 namespaces
```
# Deploy All k8s Objects
kubectl apply -f kube-manifests/  
kubectl apply -f kube-manifests/ -n dev1
kubectl apply -f kube-manifests/ -n dev2

# List all objects from default, dev1 & dev2 Namespaces
kubectl get all -n default
kubectl get all -n dev1
kubectl get all -n dev2
```

## Step-04: Access Application

### Default Namesapace
```
# List Services
kubectl get svc

# Access Application
http://<Public-IP-from-List-Services-Output>/app1/index.html
```

### Dev1 Namespace
```
# List Services
kubectl get svc -n dev1

# Access Application
http://<Public-IP-from-List-Services-Output>/app1/index.html
```
### Dev2 Namespace
```
# List Services
kubectl get svc -n dev2

# Access Application
http://<Public-IP-from-List-Services-Output>/app1/index.html
```
## Step-05: Clean-Up
```
# Delete namespaces dev1 & dev2
kubectl delete ns dev1
kubectl delete ns dev2

# List all objects from dev1 & dev2 Namespaces
kubectl get all -n dev1
kubectl get all -n dev2

# List Namespaces
kubectl get ns

# Delete App from default Namespace (Dont Delete default Namespace - k8s default service exists in it)
kubectl delete -f kube-manifests/

# Get all from All Namespaces
kubectl get all -all-namespaces
```
