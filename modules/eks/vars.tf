variable "vpc_id" {}


variable "eks-cluster-iam-role-name" { }

variable "eks-cluster-aws-security-group-name" {}

variable "eks-cluster-aws-security-group-tag-name" { }

variable "eks-worker-node-iam-role-name" { 
}

variable "aws_iam_instance_profile-name" { 
}

variable "aws_security_group-name" { 
}

variable "aws_launch_configuration_name_prefix" {
}


variable "aws_autoscaling_group_name" {
}


variable "cluster-name" {
}

variable vpc_subnet_ids { 
	type = "list"
	#default = []
}

variable vpc_public_subnet_ids { 
	type = "list"
	#default = []
}



variable "aws_region_name"  {}


variable "instance_type"  {}

variable "EC2_KEY_NAME" {
}

