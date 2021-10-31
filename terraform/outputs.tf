output "cdn_bucket_domain_name" {
  value       = module.cloudfront_distribution.cdn_bucket_domain_name
  description = "Domain of the bucket used by CloudFront"
}

output "cdn_bucket_name" {
  value       = module.cloudfront_distribution.cdn_bucket_name
  description = "Name of the bucket used by CloudFront"
}

output "cdn_bucket_arn" {
  value       = module.cloudfront_distribution.cdn_bucket_arn
  description = "ARN of the bucket used by CloudFront"
}

output "cdn_log_bucket_domain_name" {
  value       = module.cloudfront_distribution.cdn_log_bucket_domain_name
  description = "Domain of the log bucket used by CloudFront"
}

output "cdn_log_bucket_name" {
  value       = module.cloudfront_distribution.cdn_log_bucket_name
  description = "Name of the log bucket used by CloudFront"
}

output "cdn_log_bucket_arn" {
  value       = module.cloudfront_distribution.cdn_log_bucket_arn
  description = "ARN of the log bucket used by CloudFront"
}

output "cf_distribution_id" {
  value       = module.cloudfront_distribution.cf_distribution_id
  description = "The distribution id of the cloudfront resource"
}

output "modify_cf_response_lambda_qualified_arn" {
  value       = module.cloudfront_distribution.modify_cf_response_lambda_qualified_arn
  description = "The qualified ARN of the lambda function attached to CloudFront"
}

