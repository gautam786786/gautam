kubelogin
To login to Kubernetes, we used to use the az aks get-credentials command which will donwload the credentials into .kube\config file and set up the command line to connect to the AKS cluster. But, when using Azure AD authentication, we get the following experience. We are asked to intercatively authenticate using the browser and code. This is not any good for DevOps pipelines which requires non-intercative mode. In addition to that, we get a warning about the deprecation of authentication using Azure CLI. Now we should use kubelogin.
Kubelogin for AKS is available as open source project: https://github.com/Azure/kubelogin.

 $ az aks get-credentials --resource-group rg-aks-cluster --name aks-cluster
Merged "aks-cluster" as current context in C:\Users\hodellai\.kube\config
 $ kubectl get nodes


Then, we should perform the following steps:

# authenticate to Azure
az login

# get the cluster credentials using `az aks get-credentials`
az aks get-credentials --resource-group rg-aks-cluster --name aks-cluster

# install and check kubelogin version
kubelogin --version

# authenticate to AKS using kubelogin and current Azure user credentials
kubelogin convert-kubeconfig -l azurecli

# test AKS connection
kubectl get nodes
kubelogin convert-kubeconfig -l azurecli will change configuration in kubeconfig file.

# view kubeconfig changes
cat \PATH\TO\.kube\config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tL<REMOVED>tLS0tCg==
    server: https://aks-54cc2d5b.hcp.westeurope.azmk8s.io:443
  name: aks-cluster
contexts:
- context:
    cluster: aks-cluster
    user: clusterUser_rg-aks-cluster_aks-cluster
  name: aks-cluster
current-context: aks-cluster
kind: Config
preferences: {}
users:
- name: clusterUser_rg-aks-cluster_aks-cluster
  user:
    exec:  --> this is the part its adding 
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - get-token
      - --server-id
      - 6dae42f8-<REMOVED>-3960e28e3630
      - --login
      - azurecli
      command: kubelogin
      env: null
      provideClusterInfo: false

In the example above, we used the credentials from the current Azure CLI user. But, we can also use Managed Identity, Service Principal or Workload Identity.

For example, to connect using SPN:

kubelogin convert-kubeconfig -l spn

export AAD_SERVICE_PRINCIPAL_CLIENT_ID=<spn client id>
export AAD_SERVICE_PRINCIPAL_CLIENT_SECRET=<spn secret>

kubectl get nodes
And to connect using Managed Identity:

kubelogin convert-kubeconfig -l msi --client-id msi-client-id
kubectl get nodes