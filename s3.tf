# resource "aws_iam_role" "replication" {

#   name = "tf-iam-role-replication-12345"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "s3.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy" "replication" {
#   name = "tf-iam-role-policy-replication-12345"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:GetReplicationConfiguration",
#         "s3:ListBucket"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_s3_bucket.bucket.arn}"
#       ]
#     },
#     {
#       "Action": [
#         "s3:GetObjectVersion",
#         "s3:GetObjectVersionAcl"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_s3_bucket.bucket.arn}/*"
#       ]
#     },
#     {
#       "Action": [
#         "s3:ReplicateObject",
#         "s3:ReplicateDelete"
#       ],
#       "Effect": "Allow",
#       "Resource": "${aws_s3_bucket.destination.arn}/*"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "replication" {
#   role       = aws_iam_role.replication.name
#   policy_arn = aws_iam_policy.replication.arn
# }

# resource "aws_s3_bucket" "destination" {
#   bucket = "gogreen-replication-02262021"

#   versioning {
#     enabled = true
#   }

#   lifecycle_rule {
#     prefix  = "config/"
#     enabled = true

#     noncurrent_version_transition {
#       days          = 90
#       storage_class = "STANDARD_IA"
#     }

#     noncurrent_version_transition {
#       days          = 1825
#       storage_class = "GLACIER"
#     }
#   }
# }

# resource "aws_s3_bucket" "bucket" {
#   #provider = aws.central
#   bucket   = "gogreen-02262021"
#   acl      = "private"

#   versioning {
#     enabled = true
#   }

#   replication_configuration {
#     role = aws_iam_role.replication.arn

#     rules {
#       id     = "gogreen-replication"
#       prefix = "bckup"
#       status = "Enabled"

#       destination {
#         bucket        = aws_s3_bucket.destination.arn
#         storage_class = "GLACIER"
#       }
#     }

#     transition {
#       days          = 90
#       storage_class = "STANDARD_IA" # or "ONEZONE_IA"
#     }

#     transition {
#       days          = 90
#       storage_class = "GLACIER"
#     }

#     expiration {
#       days = 1825
#     }
#   }
# }
