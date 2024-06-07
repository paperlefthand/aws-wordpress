variable "aws_region" {
  description = "AWS region to deploy the infrastructure"
  type        = string
  default     = "ap-northeast-1"
}

variable "env" {
  description = "dev/prod"
  type        = string
  default     = "dev"
}
variable "profile" {
  type     = string
  nullable = false
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  nullable    = false
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  nullable    = false
}