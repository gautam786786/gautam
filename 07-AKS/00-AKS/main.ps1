# Variables
$AKS_RG="rg-aks-storage-blob"
$AKS_NAME="aks-cluster"

# Create and connect to AKS cluster
az group create --name $AKS_RG --location westeurope

az aks create --name $AKS_NAME --resource-group $AKS_RG --node-count 3 --zones 1 2 3 --kubernetes-version "1.25.2" --network-plugin azure  --enable-blob-driver

az aks get-credentials -n $AKS_NAME -g $AKS_RG --overwrite-existing

kubectl get nodes