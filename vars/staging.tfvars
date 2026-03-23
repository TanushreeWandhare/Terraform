env = "staging"
aws_region = "us-east-2"

# RDS Variables
rds_instance_class        = "db.t4g.micro"
rds_allocated_storage     = 50
rds_max_allocated_storage = 200
rds_username             = "admin"
rds_password             = "StagingPassword123"  # Change this in production

# EKS Variables
project            = "cbz"
desired_nodes      = 2
max_nodes          = 5
min_nodes          = 2
node_instance_type = "t3.small"

# S3 Variables
s3_bucket_name = "cbz-easycrud-tanu"
s3_env = "staging" 