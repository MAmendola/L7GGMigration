terraform {
  backend "s3" {
    bucket = "gogreen-statefile-03022021"
    key    = "tstate/gogreen.tfstate"
    region = "us-west-2"
  }
}
