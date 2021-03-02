variable "environment" {
  description = "Logical name of the environment."
  type        = string
  default     = "Dev"
}
variable "bucket_name" {
  type    = string
  default = "gogreen-02262021" # needs exicting bucket name
}
variable "bucket_visibility" {
  type    = string
  default = "private"
}
variable "bucket_tags" {
  type    = string
  default = "cloudfront-bucket"
}
variable "s3_origin_id" {
  type    = string
  default = "gogreen-02262021"
}
variable "enabled" {
  type    = bool
  default = true
}
variable "is_ipv6_enabled" {
  type    = bool
  default = true
}
variable "comment" {
  type        = string
  default     = null
  description = "Comment field for the distribution"
}
variable "default_root_object" {
  type    = string
  default = "index.html"
}
variable "aliases" {
  type    = list(string)
  default = [] # ["mysite.example.com"]
}
variable "include_cookies" {
  type    = bool
  default = false
}
variable "log_bucket" {
  type    = string
  default = "logb-bucket"
}
variable "log_prefix" {
  default = "cf_logs"
}
variable "allowed_methods" {
  type    = list(any)
  default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}
variable "cached_methods" {
  type    = list(any)
  default = ["GET", "HEAD"]
}
variable "min_ttl" {
  default = "0"
}
variable "default_ttl" {
  default = "3600"
}
variable "max_ttl" {
  default = "86400"
}
variable "headers" {
  type    = list(any)
  default = []
}
variable "query_string" {
  type    = bool
  default = "false"
}
variable "forward" {
  type    = string
  default = "none"
}
variable "compress" {
  type    = bool
  default = "true"
}
variable "viewer_protocol_policy" {
  type    = string
  default = "allow-all"
}
variable "price_class" {
  type    = string
  default = "PriceClass_200"
}
variable "restriction_type" {
  type    = string
  default = "none"
}
variable "locations" {
  type    = list(any)
  default = []
}
variable "cloudfront_default_certificate" {
  type    = bool
  default = "true"
}