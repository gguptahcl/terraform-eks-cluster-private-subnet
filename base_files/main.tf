module "vpc" {
  source = "../modules/vpc"

  vpc_name = "${var.vpc_name}"
  vpc_cidr = "${var.vpc_cidr}"
  vpc_subnet_count = "${var.vpc_subnet_count}"
  cluster-name = "${var.cluster-name}"	
	
  vpc_name_tag = "${var.vpc_name_tag}"	
  vpc_internet_gateway_name_tag = 	"${var.vpc_internet_gateway_name_tag}"	

  availability-zones = "${data.aws_availability_zones.available.names}"	
  vpc_subnet_count = "${var.vpc_subnet_count}"	
  vpc_subnet_cidr_block = "${var.vpc_subnet_cidr_block}"
  vpc_public_subnet_cidr_block = "${var.vpc_public_subnet_cidr_block}"

}


module "eks" {
  source = "../modules/eks"
  cluster-name = "${var.cluster-name}"	
  eks-cluster-iam-role-name = "${var.eks-cluster-iam-role-name}" 
  eks-cluster-aws-security-group-name = "${var.eks-cluster-aws-security-group-name}"	
  eks-cluster-aws-security-group-tag-name = "${var.eks-cluster-aws-security-group-tag-name}"
  eks-worker-node-iam-role-name = "${var.eks-worker-node-iam-role-name}"
  aws_iam_instance_profile-name = "${var.aws_iam_instance_profile-name}"
  aws_security_group-name = "${var.aws_security_group-name}"

  aws_launch_configuration_name_prefix = "${var.aws_launch_configuration_name_prefix}"
  aws_autoscaling_group_name = "${var.aws_autoscaling_group_name}"
  vpc_id       = "${module.vpc.vpc_id}"
  vpc_subnet_ids = "${module.vpc.vpc_subnet_ids}"
  vpc_public_subnet_ids = "${module.vpc.vpc_public_subnet_ids}"
  aws_region_name = "${data.aws_region.current.name}"
  instance_type    = "${var.instance_type}"
  EC2_KEY_NAME    = "${var.EC2_KEY_NAME}"	
}


