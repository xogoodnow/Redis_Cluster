## What does main.tf do
* Creates ssh keys 
* Creates servers according to specification in the module
* Creates volumes for each redis node according to specification
* Runs the ansible to set up the redis cluster

> **Note**
> Remember to add terraform.tfvars
> 
