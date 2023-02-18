# assing value of az acr check-name -n thakur1 | convert-json to $acr
$acr = az acr check-name -n thakur1 | convert-json 


if($acr.nameAvailable -match "True")  #If value matches than do the below else do that is on line 8
    {az acr create -n thakur1 -g gautam --sku stanDarD}
    else {
        write-host "acr exists"
    }

# assigning values
$gautam = gautam:latest    
$image = az acr repository show --name thakur1 --image gautam:latest

if($image.name -match $gautam)
    {write-host "image exists"}
    else {
        az acr login --name thakur1
        docker builD -t gautam:latest .
        docker tag gautam:latest thakur1.azurecr.io/gautam:latest
        docker push thakur1.azurecr.io/gautam:latest 
    }



# Below is short cut to the above, you will need a docker file     
    # az group create -l uksouth -n gautam
    # az acr create -n thakur1 -g gautam --sku Standard
    # az acr login --name thakur1
    # docker build --tag gautam:latest .
    # docker tag gautam:latest thakur1.azurecr.io/gautam:latest
    # docker push thakur1.azurecr.io/gautam:latest    