terraform {
  backend "s3" {
    bucket = "go-green-02262021"
    key    = "tstate/gogreen.tfstate"
    region = "us-west-2"
  }
}
