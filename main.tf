provider "aws" {
    region = "ap-northeast-2"
}
module "eks" {
    source = "./modules/eks"
    env = "dev"
    desired_size = 2
    min_size = 1
    max_size = 3
    project = "cbz"
    
    }