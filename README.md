# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Policy - The policy is defined in the deny-untagged-resource-policy-rule.json file. I have defined a policy which rejects resources which are not tagged. I used the Microsoft Azure Cloud Shell to upload the policy, run the below commands to create the policy defination and associate the policy to all subscription scope.
* For policy definition creation - az policy definition create --name "UntaggedResourcePolicy" --display-name "Deny resources with no tags" --description "This policy denies * creation of all resources that have not been tagged." --rules deny-untagged-resource-policy-rule.json --mode "All" --version "1.0.0"
For policy assignemnt  - az policy assignment create --policy UntaggedResourcePolicy

Refer to the policy_screenshots dirctory for the images.

2. Packer - I updated the server.json instructions fir packer to build. However Azure Cloud Shell does not have packer installed and hence it can be run from there. Instead I made a Github actions workflow to login to azure, install packer, build image and push the image to Azure. The relevent components are described below.
* Added the Azure Lab creadentials (client-id, client-secret,subscription-id,tenant-id) in repository secrets.
* .github\workflows\packer-build-image.yml - the action file containing the steps to make the image using Github
* server.json and server.pkr.hcl - While running in Github actions, it complained about packer plugin only using HCL2 format insteda of JSON. Hence I made a hcl version of the server.json file.

This resulted in successful run of the Github actions and the image was created successfully in the Azure account. Refer to the packer_screenshots dirctory for the images.

3. Terraform - The Terraform scripts are main.tf and vars.tf. Next the Colud sheel was used to run terraform init, validate, plan and apply to create the resources. Later terraform destroy was used to delete the resources.

Refer to the terraform_screenshots dirctory for the images.

The terraform vars.tf file can be used to customize the terraform build. All these are input to the terraform process. For example - 
* prefix - I used srirup-web to add prefix to the resources. It can be epanded to use various env specific versions.
* location - I used northeurope as the location. This creates all the resources in Europe North and can use the packer image also in northeurope.
* admin_username & admin_password - Used to setup the connection credentials to the VMs
* vm_counter - The default value used is 2. It can be made generic so that the number of VMs created can be controlled.

Additionally a terraform .tfvars file can be made to set these values for various environments.

### Output
The Terraform output is in solution.plan file.

