terraform {
    backend "s3" {
        bucket = "cbz-terraform-b48"
        region = "ap-northeast-2"
        key = "terraform.tfstate"
    }
}


provider "aws" {
    region = var.aws_region
}

module "rds" {
    source = "modules/rds"
    project            = var.eks_project
    instance_class        = var.rds_instance_class
    allocated_storage     = var.rds_allocated_storage
    max_allocated_storage = var.rds_max_allocated_storage
    username             = var.rds_username
    password             = var.rds_password
    environment          = var.environment
}


module "eks" {
    source = "./modules/eks"
    
    project            = var.project
    desired_nodes      = var.desired_nodes
    max_nodes          = var.max_nodes
    min_nodes          = var.min_nodes
    node_instance_type = var.node_instance_type
    env       = var.env
}


module "s3" {
    source = "modules/s3"
    
    bucket_name  = var.s3_bucket_name
    environment  = var.s3_environment
}
