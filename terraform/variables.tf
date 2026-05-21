variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "starttech"
}

variable "frontend_bucket_name" {
  description = "S3 bucket name for frontend"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "mongo_uri" {
  description = "MongoDB Atlas URI"
  type        = string
  sensitive   = true
}

variable "asg_min_size" {
  type    = number
  default = 1
}

variable "asg_max_size" {
  type    = number
  default = 4
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "jwt_secret_key" {
  description = "JWT secret key for auth"
  type        = string
  sensitive   = true
  default     = "starttech-super-secret-jwt-key-2024"
}

variable "allowed_origins" {
  description = "Allowed CORS origins"
  type        = string
  default     = "https://d1nhyre8kou1dm.cloudfront.net"
}