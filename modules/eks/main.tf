resource "aws_iam_role" "cluster_role" {
  name = "cluster_role-${var.project}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
    tags = {
        env = var.env
    }
}
resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
  #name       = "cluster_policy_attachment"
 role     = aws_iam_role.cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}


# Create an IAM Role for the Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role-${var.project}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    env = var.env
  }
}

# Attach necessary policies to the Node Group IAM Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_vpc" "default_vpc" {
    default = true
}
 data "aws_subnets" "default" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default_vpc.id]

    }
 }

 
resource "aws_eks_cluster" "my_cluster" {
  name = "$(var.project)-my_cluster-$(var.env)"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.default.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy_attachment,
    aws_iam_role_policy_attachment.eks_service_policy
  ]
  tags = {
        env = var.env
    }
    
  }



# Create a Node Group
resource "aws_eks_node_group" "cbz_nodegroup" {
  cluster_name    = aws_eks_cluster.cbz_cluster.name
  node_group_name = "${var.project}-node-group-${var.env}"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnets.default.ids

  scaling_config {
    desired_size = var.desired_nodes
    max_size     = var.max_nodes
    min_size     = var.min_nodes
  }

  instance_types = [var.node_instance_type]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_policy
  ]

  tags = {
    Environment = var.env
  }
}