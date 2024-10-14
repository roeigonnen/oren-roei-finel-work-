provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}



resource "aws_eks_cluster" "demo" {
  name     = "demo-cluster"
  role_arn = aws_iam_role.demo.arn

  tags = {
    Name = "Team-H"
  }

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "kubernetes_namespace" "app_namespace" {
  depends_on = [aws_eks_cluster.demo]  # Ensure the EKS cluster is created first
  metadata {
    name = "django-app"
  }
}

resource "aws_eks_node_group" "demo_nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "demo-nodes"
  node_role_arn   = aws_iam_role.demo.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t2.micro"]

  tags = {
   Name = "Team-H"
  }
}

resource "aws_iam_role" "demo" {
  name = "eks-demo-role-oren"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "kubernetes_pod" "django_pod" {
  metadata {
    name      = "django-pod"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
  }

  spec {
    container {
      name  = "django-container"
      image = "ubuntu:22.04" # Using Amazon Linux for easy installations
      command = [ "sleep", "infinity" ] # Keeps the pod running until Ansible runs
    }
  }
}