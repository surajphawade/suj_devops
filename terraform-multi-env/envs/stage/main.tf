provider "aws" {
  region = var.region
}

module "network" {
  source             = "../../modules/network"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
  name_prefix        = var.name_prefix
}