#
# Variables Configuration
#

# VPC Variable Start

variable "vpc_name" {
	#default = "demo"
	default="<CLUSTER_NAME>_VPC"
}

variable "vpc_cidr" {
	default = "10.0.0.0/16"
}

variable "vpc_subnet_count" {
	default = "2"
}

variable "vpc_subnet_cidr_block" {
	default = ["10.0.0.0/24" , "10.0.1.0/24" , "10.0.2.0/24"]
}

variable "vpc_public_subnet_cidr_block" {
	default = ["10.0.3.0/24" , "10.0.4.0/24" , "10.0.5.0/24"]
}

variable "vpc_name_tag"  {
	default="<CLUSTER_NAME>-demo-node"
}

variable "vpc_internet_gateway_name_tag"  {
	default="<CLUSTER_NAME>-demo"
}

# VPC variables End

variable "cluster-name" {
  default="<CLUSTER_NAME>"	
  type    = "string"
}

variable "eks-cluster-iam-role-name" { 
    default="<CLUSTER_NAME>-demo-cluster"
}

variable "eks-cluster-aws-security-group-name" { 
	default="<CLUSTER_NAME>-demo-cluster"
}

variable "eks-cluster-aws-security-group-tag-name" { 
	 default="<CLUSTER_NAME>-demo"	
}

variable "eks-worker-node-iam-role-name" { 
 default="<CLUSTER_NAME>-demo"
}

variable "aws_iam_instance_profile-name" { 
 default="<CLUSTER_NAME>-demo"
}


variable "aws_security_group-name" { 
 default="<CLUSTER_NAME>-demo-node"
}

variable "aws_launch_configuration_name_prefix" {
    default="<CLUSTER_NAME>-demo"	
}


variable "aws_autoscaling_group_name" {
	default="<CLUSTER_NAME>-demo"
}

variable "instance_type"  {
	default="t2.small"
}

variable "EC2_KEY_NAME"  {
	default="TerraformEKSDemoKeyPair"
}

