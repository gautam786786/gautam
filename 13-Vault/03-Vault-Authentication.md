# Vault Authentication

# UI using username and password

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

# CLI using username and password

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


#The user can’t see much or do anything and we need to assign the policy 