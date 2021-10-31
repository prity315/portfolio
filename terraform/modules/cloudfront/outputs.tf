output "cdn_bucket_domain_name" {
  value       = aws_s3_bucket.cdn_bucket.bucket_domain_name
  description = "Domain of the bucket used by CloudFront"
}

output "cdn_bucket_name" {
  value       = aws_s3_bucket.cdn_bucket.bucket
  description = "Name of the bucket used by CloudFront"
}

output "cdn_bucket_arn" {
  value       = aws_s3_bucket.cdn_bucket.arn
  description = "ARN of the bucket used by CloudFront"
}

output "cdn_log_bucket_domain_name" {
  value       = aws_s3_bucket.cf_log_bucket.bucket_domain_name
  description = "Domain of the log bucket used by CloudFront"
}

output "cdn_log_bucket_name" {
  value       = aws_s3_bucket.cf_log_bucket.bucket
  description = "Name of the log bucket used by CloudFront"
}

output "cdn_log_bucket_arn" {
  value       = aws_s3_bucket.cf_log_bucket.arn
  description = "ARN of the log bucket used by CloudFront"
}

output "cf_distribution_id" {
  value       = aws_cloudfront_distribution.cf_distribution.id
  description = "The distribution id of the cloudfront resource"
}

output "modify_cf_response_lambda_qualified_arn" {
  value       = aws_lambda_function.modify_cf_response.qualified_arn
  description = "The qualified ARN of the lambda function attached to CloudFront"
}
