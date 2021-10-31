locals {
  s3_origin_id = "S3-${aws_s3_bucket.cdn_bucket.bucket}"
  log_prefix   = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}cf-log"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "CloudFront Origin Access Identity"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.comment
  default_root_object = var.default_root_object
  aliases             = [var.alias, var.alt_alias]

  origin {
    domain_name = "${aws_s3_bucket.cdn_bucket.bucket}.s3.amazonaws.com"
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.domain
    origin_id   = "Custom-${var.domain}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = var.origin_protocol_policy
      origin_ssl_protocols   = var.origin_ssl_protocols
    }
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.cf_log_bucket.bucket_domain_name
    prefix          = "${var.environment}-${local.log_prefix}"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"] //BY default GET & HEAD requests are cached.
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000

    lambda_function_association {
      event_type   = "origin-response"
      lambda_arn   = aws_lambda_function.modify_cf_response.qualified_arn
      include_body = false
    }

  }

  ordered_cache_behavior {
    path_pattern     = "/portallogin"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "Custom-${var.domain}"

    forwarded_values {
      query_string = true
      headers      = ["User-Agent"]

      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = var.viewer_protocol_policy

    lambda_function_association {
      event_type   = "origin-response"
      lambda_arn   = aws_lambda_function.modify_cf_response.qualified_arn
      include_body = false
    }

  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.aws_acm_certificate_arn
    cloudfront_default_certificate = var.aws_acm_certificate_arn == "" ? "1" : "0"
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 300
    response_page_path    = "/index.html"
  }

  tags = var.null_label_tags
}
