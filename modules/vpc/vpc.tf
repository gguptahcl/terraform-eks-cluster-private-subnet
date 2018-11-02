#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#


resource "aws_vpc" "demo" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = "${
    map(
     "Name", "${var.vpc_name_tag}" ,
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}


resource "aws_subnet" "public_subnet" {
  count = "${var.vpc_subnet_count}"	
  availability_zone = "${var.availability-zones[count.index]}"
  cidr_block        =  "${var.vpc_public_subnet_cidr_block[count.index]}"
  vpc_id            = "${aws_vpc.demo.id}"
  tags = "${
    map(
     "Name", "${var.vpc_name_tag}" ,
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}


resource "aws_subnet" "demo" {
  count = "${var.vpc_subnet_count}"	
  availability_zone = "${var.availability-zones[count.index]}"
  cidr_block        =  "${var.vpc_subnet_cidr_block[count.index]}"
  vpc_id            = "${aws_vpc.demo.id}"
  tags = "${
    map(
     "Name", "${var.vpc_name_tag}" ,
     "kubernetes.io/role/internal-elb" , "1"	
    )
  }"
}

resource "aws_internet_gateway" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  tags {
    Name = "${var.vpc_internet_gateway_name_tag}"
  }
}



resource "aws_eip" "nat_eip" {
  vpc = true
  tags {
    Environment = "eks-terraform-demo"
  }
}

resource "aws_eip" "nat_eip_2" {
  vpc = true
  tags {
    Environment = "eks-terraform-demo"
  }
}


// create nat once internet gateway created
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.nat_eip.id}"
  #subnet_id = "${aws_subnet.eks-public.id}"
  subnet_id = "${aws_subnet.public_subnet.*.id[0]}"

  depends_on = ["aws_internet_gateway.demo"]
  tags {
    Environment = "eks-terraform-demo"
  }
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = "${aws_eip.nat_eip_2.id}"
  #subnet_id = "${aws_subnet.eks-public-2.id}"

  subnet_id = "${aws_subnet.public_subnet.*.id[1]}"

  depends_on = ["aws_internet_gateway.demo"]
  tags {
    Environment = "eks-terraform-demo"
  }
}


//Create private route table and the route to the internet
//This will allow all traffics from the private subnets to the internet through the NAT Gateway (Network Address Translation)

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.demo.id}"
  tags {
    Environment = "eks-terraform-demo"
    Name = "private-route-table"
  }

}

resource "aws_route_table" "private_route_table_2" {
vpc_id = "${aws_vpc.demo.id}"
  tags {
    Environment = "eks-terraform-demo"
    Name = "private-route-table-2"
  }
}


resource "aws_route" "private_route" {
  route_table_id  = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
}

resource "aws_route" "private_route_2" {
  route_table_id  = "${aws_route_table.private_route_table_2.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway_2.id}"
}


// public route table
resource "aws_route_table" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo.id}"
  }
}

resource "aws_route_table_association" "demo" {
  count = 2
  #subnet_id      = "${aws_subnet.demo.*.id[count.index]}"
  subnet_id      = "${aws_subnet.public_subnet.*.id[count.index]}"	
  route_table_id = "${aws_route_table.demo.id}"
}


resource "aws_route_table_association" "eks-private" {
  #subnet_id = "${aws_subnet.eks-private.id}"
  subnet_id = "${aws_subnet.demo.*.id[0]}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}


resource "aws_route_table_association" "eks-private-2" {
  #subnet_id = "${aws_subnet.eks-private-2.id}"
  subnet_id = "${aws_subnet.demo.*.id[1]}"
  route_table_id = "${aws_route_table.private_route_table_2.id}"
}


