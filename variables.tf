variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

# RDS Variables
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
}

variable "rds_max_allocated_storage" {
  description = "RDS maximum allocated storage in GB"
  type        = number
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

# EKS Variables
variable "project" {
  description = "Project name for EKS resources"
  type        = string
}

variable "desired_nodes" {
  description = "Desired number of EKS nodes"
  type        = number
}

variable "max_nodes" {
  description = "Maximum number of EKS nodes"
  type        = number
}

variable "min_nodes" {
  description = "Minimum number of EKS nodes"
  type        = number
}

variable "node_instance_type" {
  description = "EKS node instance type"
  type        = string
}

# S3 Variables
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_env" {
  description = "Environment tag for S3 bucket"
  type        = string
} 
