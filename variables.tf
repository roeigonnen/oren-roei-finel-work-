variable "aws_access_key" {
  description = "The AWS access key."
  type        = string
}

variable "aws_secret_key" {
  description = "The AWS secret key."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the existing VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private Subnet IDs to use for the EKS cluster"
  type        = list(string)
  default     = []  
}

variable "public_subnet_ids" {
  description = "List of public Subnet IDs to use for the EKS cluster"
  type        = list(string)
  default     = []  
}

variable "vpc_name" {
  description = "The name of the existing VPC"
  type        = string
  default     = "roei-vpc"
}
