variable "vpc_name" {}

variable "vpc_cidr" {}

variable "vpc_subnet_count" {}

variable "vpc_name_tag"  {}

variable "vpc_internet_gateway_name_tag"  {
}

variable "cluster-name" {} 

variable "availability-zones" {
	default = []
}

variable "vpc_subnet_cidr_block" {
	default = []
}


variable "vpc_public_subnet_cidr_block" {
	default = []
}

