module "bootstrap" {
  source = "../../bootstrap"

  frontend_bucket_name = var.fronend_bucket_name

  backend_ecr_repository_name = var.backend_ecr_repository_name

  github_repository = var.github_repository

  github_branch = var.github_branch
}
module "network" {
  source = "../../modules/network"

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs

  availability_zones = var.availability_zones

  environment  = var.environment

}

module "eks" {
  source = "../../modules/EKS"

  cluster_name       = "taskboard"
  
  kubernetes_version = var.kubernetes_version

  private_subnet_ids = module.network.private_subnet_ids

  public_access_cidrs = var.public_access_cidrs

  node_instance_types = ["t3.medium"]

  desired_size = 2
  min_size     = 1
  max_size     = 3
}
module "ecr" {
  source = "../../modules/ECR"

  repository_names = [
    "taskboard-backend"
  ]
}
module "frontend_s3" {
  source = "../../modules/frontend-s3"

  bucket_name = var.fronend_bucket_name
}