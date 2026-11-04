variable "vpc_cidr" {
  type = string
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "List of CIDR blocks for the public subnets"
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "List of CIDR blocks for the private subnets"
  default = ["10.0.3.0/24","10.0.4.0/24"]
}

variable "availability_zones" {
  type = list(string)
  description = "List of availability zones"
  default = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "environment" {
  type = string
  description = "Environment name"
  default = "prod"
}
variable "kubernetes_version" {
  type = string
  description = "Kubernetes version"
  default = "1.28"
}

variable "public_access_cidrs" {
  description = "Your public IP address in CIDR notation"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "fronend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  type        = string
  default     = "mohamedamr-taskboard-frontend"
}
variable "github_repository" {
  description = "GitHub repository in OWNER/REPO format"
  type        = string
  default     = "https://github.com/eng-mohamedamr/End-to-End-project.git"
}
variable "github_branch" {
  description = "Branch allowed to deploy to AWS"
  type        = string
  default     = "main"
}
variable "backend_ecr_repository_name" {
  description = "Name of the backend ECR repository"
  type        = string
  default     = "taskboard-backend"
}