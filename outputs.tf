output "elb_dns_name" {
  value       = aws_lb.web_lb.dns_name
  description = "The domain name of the load balancer"
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}