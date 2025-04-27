provider "aws" {  

region = "us-east-1" # Set to the desired region  

}  

# Create IAM User  

resource "aws_iam_user" "devops_user" {  

name = "devops-user-${replace(timestamp(), ":", "-")}" # Unique username with timestamp  

}  

# Attach policies to the IAM User  

resource "aws_iam_user_policy_attachment" "attach_ecr" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"  

}  

resource "aws_iam_user_policy_attachment" "attach_eks_cluster" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  

}  

resource "aws_iam_user_policy_attachment" "attach_eks_worker" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  

}  

resource "aws_iam_user_policy_attachment" "attach_ec2" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"  

}  

resource "aws_iam_user_policy_attachment" "attach_s3" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  

}  

resource "aws_iam_user_policy_attachment" "attach_cloudwatch" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"  

}  

resource "aws_iam_user_policy_attachment" "attach_iam" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"  

}  

resource "aws_iam_user_policy_attachment" "attach_codebuild" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"  

}  

resource "aws_iam_user_policy_attachment" "attach_codedeploy" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"  

}  

resource "aws_iam_user_policy_attachment" "attach_cloudfront" {  

user = aws_iam_user.devops_user.name  

policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"  

}  

# Create Access Keys for the IAM User  

resource "aws_iam_access_key" "devops_access_key" {  

user = aws_iam_user.devops_user.name  

}  

# Output the Access Key and Secret Key  

output "access_key" {  

value = aws_iam_access_key.devops_access_key.id  

sensitive = true  

}  

output "secret_key" {  

value = aws_iam_access_key.devops_access_key.secret  

sensitive = true  

}  

# VPC  

resource "aws_vpc" "main" {  

cidr_block = "10.0.0.0/16"  

tags = {  

Name = "main-vpc"  

}  

}  

# Subnet 1  

resource "aws_subnet" "subnet1" {  

vpc_id = aws_vpc.main.id  

cidr_block = "10.0.1.0/24"  

availability_zone = "us-east-1a"  

tags = {  

Name = "subnet-1"  

}  

}  

# Subnet 2  

resource "aws_subnet" "subnet2" {  

vpc_id = aws_vpc.main.id  

cidr_block = "10.0.2.0/24"  

availability_zone = "us-east-1b"  

tags = {  

Name = "subnet-2"  

}  

}  

# Security Group  

resource "aws_security_group" "devops_sg" {  

vpc_id = aws_vpc.main.id  

ingress {  

from_port = 22 # SSH  

to_port = 22  

protocol = "tcp"  

cidr_blocks = ["0.0.0.0/0"]  

}  

ingress {  

from_port = 80 # HTTP  

to_port = 80  

protocol = "tcp"  

cidr_blocks = ["0.0.0.0/0"]  

}  

ingress {  

from_port = 443 # HTTPS  

to_port = 443  

protocol = "tcp"  

cidr_blocks = ["0.0.0.0/0"]  

}  

ingress {  

from_port = 3000 # Custom TCP  

to_port = 10000  

protocol = "tcp"  

cidr_blocks = ["0.0.0.0/0"]  

}  

ingress {  

from_port = 465 # SMTPS  

to_port = 465  

protocol = "tcp"  

cidr_blocks = ["0.0.0.0/0"]  

}  

ingress {  

from_port = 27017 # Custom TCP  

to_port = 27017  

protocol = "tcp"  

cidr_blocks = ["0.0.0.0/0"]  

}  

ingress {  

from_port = 6443 # Custom TCP  

to_port = 6443  

protocol = "tcp"  

cidr_blocks = ["0.0.0.0/0"]  

}  

egress {  

from_port = 0  

to_port = 0  

protocol = "-1" # All  

cidr_blocks = ["0.0.0.0/0"]  

}  

tags = {  

Name = "devops-security-group"  

}  

}  

resource "aws_instance" "devops_instance" {  

ami = "ami-05bfc1ab11bfbf484" # Replace with a valid AMI ID for us-east-1  

instance_type = "t2.micro"  

subnet_id = aws_subnet.subnet1.id  

# Replace security_groups with vpc_security_group_ids  

vpc_security_group_ids = [aws_security_group.devops_sg.id]  

tags = {  

Name = "DevOpsInstance"  

}  

}  

# EKS Cluster  

resource "aws_eks_cluster" "devops_cluster" {  

name = "devops-cluster"  

role_arn = aws_iam_role.eks_role.arn  

vpc_config {  

subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]  

}  

}  

resource "aws_iam_role" "eks_role" {  

name = "EKSClusterRole"  

assume_role_policy = jsonencode({  

Version = "2012-10-17"  

Statement = [  

{  

Action = "sts:AssumeRole"  

Principal = {  

Service = "eks.amazonaws.com"  

}  

Effect = "Allow"  

Sid = ""  

},  

]  

})  

}  

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {  

policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  

role = aws_iam_role.eks_role.name  

}  

# ECR Repository  

resource "aws_ecr_repository" "devops_repository" {  

name = "devops-repo"  

tags = {  

Name = "DevOpsECRRepository"  

}  

}  

 #chmod +x create_terraform_structure.sh

 #./create_terraform_structure.sh