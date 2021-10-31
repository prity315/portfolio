resource "aws_s3_bucket" "cdn_bucket" {
  bucket        = "${var.null_label_prefix}-${var.cdn_bucket}"
  acl           = "private"
  force_destroy = true

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html?v=1"
    error_document = "index.html?v=1"
  }

  versioning {
    enabled = true
  }

  tags = var.null_label_tags

}

resource "aws_s3_bucket_object" "cdn_bucket_index" {
  bucket        = aws_s3_bucket.cdn_bucket.bucket
  key           = "index.html"
  cache_control = "no-cache,public,max-age=0"
}

resource "aws_s3_bucket_policy" "cdn_bucket" {
  bucket = aws_s3_bucket.cdn_bucket.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
            "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": [
        "${aws_s3_bucket.cdn_bucket.arn}/*"
      ],
        "Principal": {
                "AWS": ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
        }
      }
    ]
  }
EOF
}

resource "aws_s3_bucket" "cf_log_bucket" {
  bucket        = "${var.null_label_prefix}-log-bucket"
  acl           = "log-delivery-write"
  force_destroy = true
}
