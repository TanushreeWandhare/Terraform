# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch the default Subnet IDs
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Use the first default Subnet (for simplicity)
data "aws_subnet" "default" {
  id = data.aws_subnets.default.ids[0]
}

# Create a Security Group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.default.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open access (use cautiously, better to restrict in production)
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "rds-sg"
    env = var.env
  }
}

# Create an RDS MySQL Instance
resource "aws_db_instance" "cbz_db_instance" {
  allocated_storage    = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group-t.default.name
  skip_final_snapshot  = true
  tags = {
    Name        = "cbz-db-instance"
    env = var.env
  }
}

# Create a DB Subnet Group using default subnets
resource "aws_db_subnet_group-t" "default" {
  name       = "${var.project}-${var.env}-db-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
  tags = {
    Name        = "default-db-subnet-group"
    env = var.env
  }
}