
az group create -l uksouth -n gautam
az acr create -n thakur1 -g gautam --sku Standard
az acr login --name thakur1
docker build --tag gautam:latest .
docker tag gautam:latest thakur1.azurecr.io/gautam:latest
docker push thakur1.azurecr.io/gautam:latest
