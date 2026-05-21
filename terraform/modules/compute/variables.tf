variable "app_name"             { type = string }
variable "environment"          { type = string }
variable "aws_region"           { type = string }
variable "vpc_id"               { type = string }
variable "public_subnet_ids"    { type = list(string) }
variable "private_subnet_ids"   { type = list(string) }
variable "alb_sg_id"            { type = string }
variable "backend_sg_id"        { type = string }
variable "instance_type"        { type = string }
variable "key_name"             { type = string }
variable "asg_min_size"         { type = number }
variable "asg_max_size"         { type = number }
variable "asg_desired_capacity" { type = number }
variable "ecr_repository_url"   { type = string }
variable "redis_host"           { type = string }

variable "redis_port" {
  type    = number
  default = 6379
}

variable "mongo_uri" {
  type      = string
  sensitive = true
}

variable "jwt_secret_key" {
  type      = string
  sensitive = true
}

variable "allowed_origins" {
  type = string
}