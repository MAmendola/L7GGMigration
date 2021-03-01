

resource "aws_route53_zone" "l7gogreen" {
  name = "l7gogreen.com"

}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.l7gogreen.zone_id
  name    = "www.l7gogreen.com"
  type    = "A"
  records = [aws_route53_zone.l7gogreen.com]
}
alias {
   name = aws_route53_zone.www.l7gogreen.com
   zone_id = aws_route5.zone.l7gogreen.zone_id
}
