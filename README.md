# This Repository creates EKS cluster on AWS.It has 2 Public Subnets and 2 Private Subnetss. EKS Worker nodes are created in Private Subnets. 

### Contents of repo
 - base_files (Common files that are required to create EKS Cluster. These are copied for each Cluster creation) 
 - modules (contains terraform code for EKS & VPC modules)
 - createEnv.sh 
 - makefile


### Optional -- To run this script on EC2 instance on AWS : 

Use the following GIT Repo to launch AWS EC2 Instance with all required softwares installed
GIT Repo :  https://github.com/gguptahcl/aws-ec2-instance-terraform.git

### Prerequisite

If you followed the Optional step then you can Skip #1 below 

1) To execute on your own instance (local machine / aws EC2 instance),  
       install docker , aws cli & terraform , aws iam Authenticator and Kubernetes Client.

2) Update variable EC2_KEY_NAME in base_files/variables.tf

### Setup

Follow the following steps to create EKS Cluster :

1) aws configure
2) Clone Code from GIT REPO (https://github.com/gguptahcl/terraform-eks-cluster-private-subnet.git )  
3) Get into “terraform-eks-cluster-private-subnet” directory
4) Execute bash createEnv.sh {clusterName}   (It will create a folder with {clusterName}, copy the required files in this folder and run the command to create EKS cluster)   
5) Any time you want to see the POD’s running in this cluster , execute following commands :
	export KUBECONFIG=~/.kube/ clusterName -config
	kubectl get pods -n kube-system


### Rollbacking setup

cd {clusterName}  (folder created after Executing bash createEnv.sh {clusterName} command from Setup steps )
```
terraform destroy 
```


### Notes

This repo also has the code for Auto Scaling Groups in (modules/eks/eks-worker-nodes.tf ) which has not been validated
