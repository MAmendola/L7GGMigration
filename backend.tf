resource "aws_a3_bucket" "statef" {
  bucket_name = "gogreen-statefile-03022021"
}

terraform {
  backend "s3" {
    bucket = "gogreen-statefile-03022021"
    key    = "tstate/gogreen.tfstate"
    region = "us-west-2"
  }
}
