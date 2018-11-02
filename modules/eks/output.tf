output "node-role-arn" {
  value = "${aws_iam_role.demo-node.arn}"
}

output "cluster-endpoint" {
  value = "${aws_eks_cluster.demo.endpoint}"
}


output "cluster-certificate-authority-data" {
  value = "${aws_eks_cluster.demo.certificate_authority.0.data}"
}
