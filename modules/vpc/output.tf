output "vpc_id" {
  value = "${aws_vpc.demo.id}"
}

output "vpc_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = ["${aws_subnet.demo.*.id}"]
}

output "vpc_public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = ["${aws_subnet.public_subnet.*.id}"]
}

