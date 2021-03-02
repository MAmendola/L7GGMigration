# this is cloudfront.tf file
  data "aws_s3_bucket" "origin" {
  bucket = var.bucket_name
}
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.environment}-cloudfront-access-identity"
}
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = data.aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = data.aws_s3_bucket.origin.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  aliases = var.aliases
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = data.aws_s3_bucket.origin.bucket
    forwarded_values {
      query_string = var.query_string
      headers      = var.headers
      cookies {
        forward = var.forward
      }
    }
    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               =  var.compress
  }
  price_class = var.price_class
  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.locations
    }
  }
  tags = {
    Environment = "var.environment"
      }
  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_default_certificate
  }
}