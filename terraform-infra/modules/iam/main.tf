resource "aws_iam_user" "devops" {
  name = "devops-user"
}

output "iam_user_name" {
  value = aws_iam_user.devops.name
}
