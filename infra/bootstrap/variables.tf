variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "bucket_name" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "mohamedamr-terraform-state-2026"
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

variable "github_repository" {
  description = "GitHub repository in OWNER/REPO format"
  type        = string
  default     = "https://github.com/eng-mohamedamr/End-to-End-project.git"
}
variable "frontend_bucket_name" {
  description = "Name of the frontend S3 bucket"
  type        = string
}
