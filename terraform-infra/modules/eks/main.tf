resource "aws_eks_cluster" "main" {
  name     = "main-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.subnets
  }
}

output "eks_cluster_name" {
  value = aws_eks_cluster.main.name
}
