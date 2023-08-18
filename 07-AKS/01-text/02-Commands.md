# Configure Cluster Creds (kube config) for Azure AKS Clusters
az aks get-credentials --resource-group aks-rg1 --name aksdemo1 --overwrite-existing && kubelogin convert-kubeconfig

# Node Status ->                                     
kubectl get nodes/   -o wide

# List Pods →                                           
kubectl get pods/ po  / -o wide

# Describe the pod →                         
Kubectl describe pod <pod name>

# Delete Pod →                                     
kubectl delete pod <Pod name>

# Create a Pod →                                  
kubectl run <desired-pod-name> --image <Container-Image> 

# Get Pods from Namespace →        
kubectl get pods -n <namespace> (kubectl get namespace/ns)

# Logs→                                                   
k logs <pod-name>

# stream pod logs with -f-->              
k logs -f <pod-name>

Services 

# Service Info →                                        
kubectl get service    /svc.    /-o wide

# Delete Service->                              
delete svc <YourServiceName>

# Verify if Service got deleted →        
kubectl get svc.   -n <namespace>

 
Replicaset 

# Replicaset Info →                                    
kubectl get replicaset /  rs

# Describe  ReplicaSet->                      
kubectl describe rs/<replicaset-name>

# Delete ReplicaSet->                             
kubectl delete rs <ReplicaSet-Name>

# Verify if ReplicaSet got deleted->   kubectl get rs

Namespace

# Namespace Info →                                    
kubectl get namespace 

# Get all Objects in  namespace-->        
kubectl get all. 
kubectl get all --namespace <external-dns>

# Create name space →                            
kubectl create ns <name space>

Deployment 

# Deployments->                                      
kubectl get deployments --all-namespaces

#  Delete →                                                       
kubectl delete -n NAMESPACE deployment DEPLOYMENT


# NetworkPolicies-->                               
k get NetworkPolicies -n gatekeeper-system
k edit NetworkPolicies -n gatekeeper-system
k apply -f <file> -n <namespace>

+31 6 83106811

#  rolebindings
kubectl get rolebindings,clusterrolebindings \
--all-namespaces  \
-o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind=="ServiceAccount")].name

kubectl get clusterroles
kubectl get clusterrolebindings
find your role name and then delete
kubectl delete clusterrolebinding name
kubectl delete clusterrole name




