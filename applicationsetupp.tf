provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Step 1: Create IAM role for EKS node groups
resource "aws_iam_role" "demo" {
  name = "eks-demo-role-oren-roei-20-10-2024-seventh" # Change date to any new role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Step 2: Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "node_policy_attachments" {
  count      = 3
  role       = aws_iam_role.demo.name
  policy_arn = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ][count.index]
}

# Step 3: Create EKS cluster
resource "aws_eks_cluster" "demo" {
  name     = "roei-oren-cluster-2" # the name of the cluster in aws
  role_arn = aws_iam_role.demo.arn

  tags = {
    Name = "Team-H"
  }

   vpc_config {
    subnet_ids  = concat(var.private_subnet_ids, var.public_subnet_ids)  # Use both private and public subnets
  }
}

# Data source to get the authentication token for EKS
data "aws_eks_cluster_auth" "demo" {
  name = aws_eks_cluster.demo.name
}

# Step 4: Configure the Kubernetes provider
provider "kubernetes" {
  host                   = aws_eks_cluster.demo.endpoint
  token                  = data.aws_eks_cluster_auth.demo.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.demo.certificate_authority[0].data)

 
}

resource "aws_launch_template" "eks_launch_template" {
  name_prefix   = "eks-test-1"
  instance_type = "t2.micro"       # Change to your preferred instance type

  # Specify the SSH key name here
  key_name = "roei-gonnen-new-key"  # Replace with your actual SSH key name

  lifecycle {
    create_before_destroy = true
  }
}

# Step 4: Create EKS node groups using the IAM role
resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.demo.arn
  subnet_ids      = var.private_subnet_ids  

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = "$Latest"
  }

  tags = {
    Name = "Team-H-Private"
    
  }
}

resource "aws_eks_node_group" "public_nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "public-nodes"
  node_role_arn   = aws_iam_role.demo.arn
  subnet_ids      = var.public_subnet_ids  

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

 launch_template {
    id      = aws_launch_template.eks_launch_template.id
    version = "$Latest"
  }
  

  tags = {
    Name = "Team-H-Public"
    
  }
}

# Step 5: Create the Kubernetes namespace (after the cluster is available)
resource "kubernetes_namespace" "app_namespace" {
  depends_on = [aws_eks_cluster.demo]  
  metadata {
    name = "django-app"
  }
}
