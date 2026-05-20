output "cloudfront_url" {
  description = "CloudFront URL for frontend"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation)"
  value       = aws_cloudfront_distribution.frontend.id
}

output "alb_dns_name" {
  description = "Backend API URL"
  value       = "http://${module.compute.alb_dns_name}"
}

output "s3_bucket_name" {
  description = "Frontend S3 bucket"
  value       = module.storage.bucket_name
}

output "redis_endpoint" {
  description = "Redis host"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "backend_log_group" {
  description = "CloudWatch log group"
  value       = module.monitoring.backend_log_group_name
}