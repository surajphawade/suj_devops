module "network" {
  source = "./modules/network"
}

module "iam" {
  source = "./modules/iam"
}

module "eks" {
  source = "./modules/eks"
  subnets = module.network.private_subnets
  vpc_id  = module.network.vpc_id
}
