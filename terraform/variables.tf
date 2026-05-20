variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "muchtodo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "backend_image" {
  description = "Docker image for backend (ECR URI or Docker Hub)"
  type        = string
}

variable "mongo_uri" {
  description = "MongoDB Atlas connection string"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret key"
  type        = string
  sensitive   = true
}

variable "ec2_key_pair_name" {
  description = "Name of existing EC2 key pair for SSH access"
  type        = string
}