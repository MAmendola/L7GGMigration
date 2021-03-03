//Creates hosted zone in RT53
resource "aws_route53_zone" "gogreen" {
  name = "globalebsolutions.com"
}

//Creates record in hosted zone RT53
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.gogreen.zone_id
  name    = "www.globalebsolutions.com"
  type    = "A"
  alias {
    name    = aws_lb.web_lb.dns_name  //resolves dns name to webtier lb dns name
    zone_id = aws_lb.web_lb.zone_id   
    evaluate_target_health = true
    
  }
}

//Outputs the 4 DNS servers that route traffic to DNS record
output "name_server" {
  value = aws_route53_zone.gogreen.name_servers
}
