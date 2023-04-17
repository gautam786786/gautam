# Kubernetes node

- A node in a Kubernetes cluster is where your compute workloads run. It would be a VM or VMSS

- Each node communicates with the control plane via the API server to inform it about state changes on the node.
  

# Master 

# 1 Kube-apiserver:
It acts as a front end for the Kubernetes control plane It exposes the Kubernetes API
CLI tools like kubectl, user and even master components like scheduler, control manager, etcd and worker nodes components like (Kubelet) everything talks to the API server
The API Server . It also acts as the gateway to the cluster, so the API server must be accessible by clients from outside the cluster.


# 2  Etcd:
Used as Kubernetes’s backing store for all cluster data
It stores all the master and worker node information

# 3. Kuber-scheduler:

The scheduler is responsible for distributing containers across multi nodes
It watches for newly created Pods with no assigned nodes and selects a node for them to run on.

# 4 Kuber-control-manager

Controllers are responsible for noticing and responding when nodes, container,s or endpoints go down, They make decisions to bring up new containers in such cases
- Node Controller: Responsible for noticing and responding when nodes go down
- Replication controller: Responsible for maintaining the correct number of pods for every replication controller object in the system
- Endpoint controller: Populates the endpoint object( thst is join services and pods)
- Service Account and token controller: Creates default accounts and API access for new namespaces


# 5 Cloud-controller-manager:

- A Kubernetes control plane component that embeds cloud-specific control logic
It only runs controllers that are specific to your cloud provider
- On- Premises Kubernetes cluster will not have this components
- Node controller: For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
- Route Controller: For Setting up routes in the underlying cloud infrastructure
- Service Controller: For Creating, updating and deleting cloud provider load balancer  

 

# Worker Node

# 1 Container Runtime:
Is the underlying software where we run all these components
We are using docker. But we have other runtimes like rkt, container-d etc

# 2 Kubelet:
- Kuberlet is the agent that runs on every node in the cluster
- This agent is responsible for making sure that containers are running in a Pod on node.


# 3 Kube-proxy
It is a network proxy that runs on each node in your cluster
It maintains network rules on nodes
In short, these network rules allow network communication to    yor pods from network session inside or outside of your cluster         


# Kubernetes pods
- The workloads that you run on Kubernetes are containerized apps. Unlike in a Docker environment, you can't run containers directly on Kubernetes. You package the container into a Kubernetes object called a pod.
- A single pod can hold a group of one or more containers. However, a pod typically doesn't contain multiples of the same app.

# There are various types of pods:

- ReplicaSet, the default, is a relatively simple type. It ensures the specified number of pods are running A selector enables the replica set to identify all the pods running underneath it. Using this feature, you can manage pods labeled with the same value as the selector value, but not created with the replicated set.
- Deployment is a declarative way of managing pods via ReplicaSets. Includes rollback and rolling update mechanisms Deployments make use of YAML-based definition files, and make it easy to manage deployments
- Daemonset is a way of ensuring each node will run an instance of a pod. Used for cluster services, like health monitoring and log forwarding
- StatefulSet is tailored to managing pods that must persist or maintain state
- Job and CronJob run short-lived jobs as a one-off or on a schedule.



# Node pools
- You create node pools to group nodes in your AKS cluster. When you create a node pool, you specify the VM size and OS type (Linux or Windows) for each node in the node pool based on application requirement. To host user application pods, node pool Mode should be User otherwise System.

- By default, an AKS cluster will have a Linux node pool (System Mode) whether it's created through Azure portal or CLI. However, you'll always have an option to add Windows node pools along with default Linux node pools during the creation wizard in the portal, via CLI, or in ARM templates.

- Node pools use Virtual Machine Scale Sets as the underlying infrastructure to allow the cluster to scale the number of nodes in a node pool. New nodes created in the node pool will always be the same size as you specified when you created the node pool. 


# Kubernetes Networking
- Within a pod, containers can communicate without any restrictions. Containers within a pod exist within the same network namespace and share an IP. This means containers can communicate over localhost. Pods can communicate with each other using the pod IP address, which is reachable across the cluster.
- Moving from pods to services, or from external sources to services, requires going through kube-prox