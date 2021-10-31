variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region for the account used"
}

variable "environment" {

}

variable "role_arn" {

}

variable "key" {

}

variable "domain" {

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

variable "aws_acm_certificate_arn" {

}

variable "name_prefix" {

}
