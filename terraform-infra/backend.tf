terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "devops/terraform.tfstate"
    region = "us-east-1"
  }
}
