# Vault Authentication

# Authentication UI using username and password

- Login the UI 
- Access --> auth method
- lets use username 
- Login using token 
- enable a new method under access
- Click on usrname and password
- click on create
- enable method nd upadate
- Notice we have to auth method now
- click userpass 
- create users
- add username and password and save
- Login with username and password

# Authentication CLI using username and password

```t

# Login a pod
k exec -it <pod> bin/bash or bin/sh

vault status

# I need to enable auth for username and password
vault login
#using the  root token 

#enable vault auth userpass
vault auth enable userpass
#Check-in vault that auth is enabled 

#Create user and password
vault write auth/userpass/users/gautam password=gautam
# Verify this in UI 

#Login with the user
vault login -method=userpass username=gautam
#login using the password


#The user can’t see much or do anything and we need to assign the policy 
``` 

# Authentication API

```t
#create a payload.json file and add the password below
"password": "gautam"

#Do a curl command to login 
curl -k -h 'X-vault-Token: <toke> -x post --data @payload.json http://<ip>/v1/auth/userspass/users/gautam 

``` 

# Enable userpass using API 
curl -k --header 'X-vault-Token: <toke> --request POST --data '{"type": "userpass"}

# login user using API 
