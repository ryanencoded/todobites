resource "aws_route53_record" "app_dns" {
  name    = var.domain_name
  type    = "A"
  zone_id = var.aws_zone_id
  alias {
    name    = aws_cloudfront_distribution.app_distribution.domain_name
    zone_id = aws_cloudfront_distribution.app_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "app_cert_dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.aws_zone_id
}