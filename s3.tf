resource "aws_iam_role" "replication-role" {

  name = "s3-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "s3-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.versioning_bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication-role.name
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_bucket" "bucket" {
  bucket = "go-green-02262021"
  acl    = "private"
  #   object_lock_configuration = false

  versioning {
    enabled = true
  }

  replication_configuration {
    role = aws_iam_role.replication-role.arn

    rules {
      id     = "rep-rule"
      prefix = "bckup"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.versioning_bucket.arn
        storage_class = "STANDARD"
      }
    }
  }

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

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    expiration {
      days = 1825
    }
  }

  lifecycle_rule {
    id      = "main-lifecycle"
    prefix  = "tmp/"
    enabled = true

    expiration {
      date = "2030-01-12"
    }
  }
}

resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "go-green-replication-02262021"
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

    noncurrent_version_transition {
      days          = 180
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 1825
    }
  }
}