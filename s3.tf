resource "aws_s3_bucket" "bucket" {
  bucket = "gogreen-02262021"
  acl    = "private"


  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = 90
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    expiration {
      days = 1825
    }
  }

  lifecycle_rule {
    id      = "tmp"
    prefix  = "tmp/"
    enabled = true

    expiration {
      days = 1825
    }
  }
}

resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "gogreen-versioning-02262021"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_expiration {
      days = 1825
    }
  }
}