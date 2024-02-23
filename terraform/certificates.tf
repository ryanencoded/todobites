resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  # subject_alternative_names = ["www.${var.domain_name}"]

  tags = {
    Environment = var.environment
    Client = var.client_name
    Project = var.project_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn         = aws_acm_certificate.app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.app_cert_dns_validation : record.fqdn]
}