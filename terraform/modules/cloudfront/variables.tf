variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region for the account used"
}

variable "cdn_bucket" {
  default = "cdn-cloudfront"
}

variable "comment" {
  default     = "Provisioned by Terraform"
  description = "Comment for Cloudfront distribution"
}

variable "default_root_object" {
  default = "index.html"
}

variable "alias" {
  default = "*.globalenglish.com"
}

variable "alt_alias" {

}

variable "origin_protocol_policy" {
  default     = "match-viewer"
  description = "Allowed values are http-only, https-only, or match-viewer"
}

variable "origin_ssl_protocols" {
  default = ["TLSv1.2", "TLSv1"]
}

variable "viewer_protocol_policy" {
  default     = "redirect-to-https"
  description = "Allowed policies are allow-all, https-only or redirect-to-https"
}

variable "environment" {

}

variable "aws_acm_certificate_arn" {

}

variable "domain" {

}

variable "name_prefix" {

}

variable "role_arn" {

}

variable "null_label_prefix" {

}

variable "null_label_tags" {

}

variable "modify_cf_response_source_dir" {
  default     = "../lambda-functions/modifyCloudFrontResponse.js"
  description = "File location of the lambda script"
}

variable "modify_cf_response_lambda_name" {
  default     = "modifyCFHeader"
  description = "Lambda function to modify the CloudFront Response Header"
}


