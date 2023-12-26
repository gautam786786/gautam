## 9) Working with Container Registry (Docker Hub)

Create a Docker Hub account at: https://hub.docker.com/.
Login to Docker Hub registry:

```bash
$ docker login
```

Tag the image with your Docker Hub ID (for me it is *houssemdocker*):

```bash
$ docker tag webapp:1.0 <houssemdocker>/webapp:1.0
```

Push the image to the registry:

```bash
$ docker push <houssemdocker>/webapp:1.0
```

## 10) Working with Container Registry (Azure Container Registry)

Make sure yiur have an Azure subscription and you have installed Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli.

Create a new Azure Container Registry (ACR) in Azure portal.

Enable *Admin* credentials from ACR.

Login to ACR:

```bash
$acrName="myacr"
az acr login -n $acrName --expose-token
```

Build the image on ACR (Optional):

```bash
az acr build -t "$acrName.azurecr.io/webapp:1.0" -r $acrName .
```

Note that image is already pushed to ACR.
