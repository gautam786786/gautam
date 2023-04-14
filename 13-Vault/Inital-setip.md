# Initial setup 

- Create an AKS cluster and Connect it to the AKS cluster 
- check is helm is installed 
```t
# check helm if it's installed 
helm                                                  

# check what charts we have 
helm list                                           

# check what repo we have 
helm repo list                                     

# Add a repo                                          
helm repo add hashicorp https://helm.release.hasicorp.com
# you can copy the URL and see what iits using 

#list the repo
helm repo list                                    

#Updat the repo
helm repo update                             

#check all version 
helm search repo vault --versions. → all the version  
``` 