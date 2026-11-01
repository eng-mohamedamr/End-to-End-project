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