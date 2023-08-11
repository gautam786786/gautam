```t
# Get the remote URL                          
git config --get remote.origin.url

# To remove a remote repository                   
git remote rm origin

# Update your local master with the origin/master
git pull origin master:master

# Now your origin/masteris up to date, so you can rebase or merge your local branch with these changes.
git fetch

# And your develop branch will be up:          
git rebase origin/master

# To go back to pervious commit                 
git reset --hard 7d2838af6180183c05969e0d1a18b4fed53682c7 (old reference)

# To clone a branch:                         
git clone -b <branch> <remote_repo>

# checkout a new branch:                       
git checkout -b <branch>

# get local branches of your repo.                
git branch

# To push Tags
Make changes
git add .
git commit -m "w"
git tag v.02 
git push --tags


# To push Changes
git add .
git commit -m "w"
git push
``` 

---
title: Install Terraform, Azure CLI and VSCode Editor
description: Install all the tools required for learning Terraform on Azure Cloud
---

## Step-01: Introduction
- Install [Terraform CLI](https://www.terraform.io/downloads.html)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Install [VS Code Editor](https://code.visualstudio.com/download)
- Install [HashiCorp Terraform plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Install [Git Client](https://git-scm.com/downloads)

[![Image](https://stacksimplify.com/course-images/azure-terraform-install-1.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-install-1.png)

## Step-02: MACOS: Terraform Install
- [Download Terraform MAC](https://www.terraform.io/downloads.html)
- [Install CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Unzip the package
```t
# Copy binary zip file to a folder
mkdir /Users/<YOUR-USER>/Documents/terraform-install
COPY Package to "terraform-install" folder

# Unzip
unzip <PACKAGE-NAME>
unzip terraform_0.15.4_darwin_amd64.zip

# Copy terraform binary to /usr/local/bin
echo $PATH
mv terraform /usr/local/bin

# Verify Version
terraform version

# To Uninstall Terraform (NOT REQUIRED)
rm -rf /usr/local/bin/terraform
``` 

## Step-03: MACOS: IDE for Terraform - VS Code Editor
- [Microsoft Visual Studio Code Editor](https://code.visualstudio.com/download)
- [Hashicorp Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Configure [Course Github Repository](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure) using VS Code Editor


## Step-04: MACOS: Install Azure CLI
- [Azure CLI Install](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Install Azure CLI - MAC](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)
```t
# Install XCode
brew update 
xcode-select --install
Observation: Verify images for reference in "image-reference" folder

# Sample Error (Without Xcode if we try az cli install it will through this error)
Error: python@3.8: the bottle needs the Apple Command Line Tools to be installed.
  You can install them, if desired, with:
    xcode-select --install


# AZ CLI Current Version (if installed)
az --version

# Install Azure CLI (if not installed)
brew update 
brew install azure-cli

# Upgrade az cli version
az --version
brew upgrade azure-cli 
[or]
az upgrade
az --version
```

[![Image](https://stacksimplify.com/course-images/xcode-install-1.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-1.png)

[![Image](https://stacksimplify.com/course-images/xcode-install-2.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-2.png)

[![Image](https://stacksimplify.com/course-images/xcode-install-3.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-3.png)

[![Image](https://stacksimplify.com/course-images/xcode-install-4.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/xcode-install-4.png)


## Step-05: Terraform - Authenticating using the Azure CLI
- [Azure Provider: Authenticating using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

## Step-06: Install Git Client
- [Download Git Client](https://git-scm.com/downloads)
- This is required when we are working with `Terraform Modules`

## Step-07: WindowsOS: Terraform & Azure CLI Install
### Step-07-01: Install Git Client
- [Download Git Client](https://git-scm.com/downloads)
- This is required when we are working with `Terraform Modules`

### Step-07-02: Install Azure CLI
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
- `Step-05:Terraform - Authenticating using the Azure CLI` is going to be same for WindowsOS too. 
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```

### Step-07-03: Install Terraform 
- [Download Terraform](https://www.terraform.io/downloads.html)
- [Install CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Unzip the package
- Create new folder `terraform-bins`
- Copy the `terraform.exe` to a `terraformbins`
- Set PATH in windows 

### Step-07-04: Configure Course Git Repo 
- [Course Git Repo](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure)
- Shorten Course folder name to smaller one. Put it in C:\ Drive root path

### Step-07-05: Install Visual Studio Code and Terraform Plugin
- [Microsoft Visual Studio Code Editor](https://code.visualstudio.com/download)
- [Hashicorp Terraform Plugin for VS Code](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- Configure [Course Github Repository](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure) using VS Code Editor

### Step-07-06: WindowsOS: Long Path Issues for Terraform CLI
- [Windows10 Long File Name or Path](https://github.com/hashicorp/terraform/issues/21173)
- [Microsoft fix](https://answers.microsoft.com/en-us/windows/forum/all/windows-10-commands-with-long-path-name-are-not/13f0f7c7-d55c-4c6c-b19d-9dfec099dd45)
- Our fix is to shorten our git repo names to see if that helps

## Step-08: LinuxOS: Terraform & Azure CLI Install
- [Download Terraform](https://www.terraform.io/downloads.html)
- [Linux OS - Terraform Install](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=script)
- `Step-05:Terraform - Authenticating using the Azure CLI` is going to be same for LinuxOS too. 
- [Course Git Repo](https://github.com/stacksimplify/hashicorp-certified-terraform-associate-on-azure)


Create Git branch using checkout
The easiest way to create a Git branch is to use the “git checkout” command with the “-b” option for a new branch. Next, you just have to specify the name for the branch you want to create.

$ git checkout -b <branch-name>
As an example, let’s say that you want to create a new Git branch from the master branch named “feature”

To achieve that, you will run the “git checkout” command with the “-b” option and add “feature” as the branch name.

$ git checkout -b feature
Switched to new branch 'feature'
As you can see, by using the “git checkout” command, you are creating a new branch and you are switching to this new branch automatically.

But what if you wanted to create a Git branch without switching to the new branch automatically?

Create Git Branch without switching
In order to create a new Git branch, without switching to this new branch, you have to use the “git branch” command and specify the name of the Git branch to be created.

$ git branch <branch_name>
You can later on switch to your new Git branch by using the “git checkout” function.

$ git checkout <branch_name>
Going back to our previous example, let’s say that you want to create a branch named “feature”.

$ git branch feature
You can inspect existing branches by running the “git branch” command with the “-a” option for all branches.

$ git branch -a
create git branch
Awesome, you have successfully created a new Git branch and you switched to it using the checkout command.

Create Git Branch from Commit
In the last sections, we have seen how you can create a new Git branch from the HEAD commit of the current branch.

In some cases, you want to create a Git branch from a specific commit in your Git history.

In order to create a Git branch from a commit, use the “git checkout” command with the “-b” option and specify the branch name as well as the commit to create your branch from.

$ git checkout -b <branch_name> <commit_sha>
Alternatively, you can use the “git branch” command with the branch name and the commit SHA for the new branch.

$ git branch <branch_name> <commit_sha>
Going back to our previous example, let’s say that you want to create a Git branch from a specific commit in your Git history.

To get commits SHA from your history, you have to use the “git log” with the “–oneline” option.

$ git log --oneline --graph

* 9127753 (HEAD -> master) Commit 3
* f2fcb99 Commit 2
* cab6e1b (origin/master) master : initial commit
To create a new Git branch from the second commit (f2fcb99), you would run the following command

$ git checkout -b feature f2fcb99
Switched to a new branch named 'feature' 
Using the “git log” command, you can verify that your branch was created from the second commit of your history.

$ git log --oneline --graph

* f2fcb99 (HEAD -> feature) Commit 2
* cab6e1b (origin/master) master : initial commit
Awesome, you have successfully created a new Git branch from a specific commit!

Create Git Branch from Tag
In previous tutorials, we have seen that Git tags are pretty useful : they can be use as reference points in your development.

As a consequence, it can be quite useful to create Git branches from existing tags.

In order to create a new Git branch from a tag, use the “git checkout” command with the “-b” option and specify the branch name as well the tag name for your new branch.

$ git checkout -b <branch_name> <tag_name>
Alternatively, if you don’t want to switch to your new branch, you can use the “git branch” with the branch name and the tag name.

$ git branch <branch_name> <tag_name>
Back to our previous example, let’s say that you want to create a new Git branch from a tag named “v1.0” in your history.

In order to list your existing tags, you can use the “git tag” command. Alternatively, you can use the “git log” command to identify a tag associated with a commit.

$ git tag
v1.0
Now that you have identified your tag, you can create a new branch from it using the “git checkout” command.

$ git checkout -b feature v1.0
Next, you can inspect your Git history in order to make sure that your new branch was indeed created from the tag.


Alternatively, you could have used the “git branch” in order to create this branch.

$ git branch feature v1.0
Note on Ambiguous Names
When you are creating new Git objects (whether they are branches, tags or commits), you might run into this error

fatal: Ambiguous object name: <object>
So why does this error happens?

This exception occurs whenever two objects are named in the exact same way : a branch and a tag for example.

Whenever you are running a command involving one of those objects, Git can not tell the difference between the two and it returns this exception.

You might run into this error when running the “checkout” command.

If you are creating a new branch from a tag named “v1.0”, but one of your branches is already named “v1.0”, you will be presented with this error

$ git checkout -b feature v1.0
warning: refname 'v1.0' is ambiguous.
warning: refname 'v1.0' is ambiguous.
fatal: Ambiguous object name: 'v1.0'.
In order to solve this issue, you have to specify that your last argument is a tag and not the branch name.

To solve ambiguous notation, simply append the refs notation to the object that is ambiguous

$ git checkout -b feature refs/tags/v1.0
Switched to a new branch 'feature'