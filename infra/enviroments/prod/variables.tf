variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "environment" {
  type = string
}
variable "kubernetes_version" {
  type = string
}

variable "public_access_cidrs" {
  description = "Your public IP address in CIDR notation"
  type        = list(string)
}
