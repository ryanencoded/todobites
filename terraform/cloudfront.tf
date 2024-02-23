
resource "aws_cloudfront_origin_access_control" "app_origin_ac" {
  name                              = "${var.project_name}-${var.environment}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "app_cache_policy" {
  name        = "${var.project_name}-${var.environment}-cache-policy"
  default_ttl = 3600
  max_ttl     = 86400
  min_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "app_origin_request_policy" {
  name    = "${var.project_name}-${var.environment}-orp"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "none"
  }
}

resource "aws_cloudfront_distribution" "app_distribution" {
  origin {
    domain_name              = aws_s3_bucket.app_bucket.bucket_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.app_origin_ac.id
    origin_path = "/${local.s3_public_folder}"
  }

  # Causing ACL error so disabling until fix discovered
  # logging_config {
  #   bucket         = aws_s3_bucket.app_bucket.bucket_domain_name
  #   include_cookies = false
  #   prefix         = "cloudfront-logs/"
  # }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  comment = "${var.project_name} for ${var.environment}"
  # aliases = ["www.${var.domain_name}"]

  custom_error_response {
    error_code           = 403
    response_page_path   = "/index.html"
    response_code        = 200
    error_caching_min_ttl = 60
  }

  custom_error_response {
    error_code           = 404
    response_page_path   = "/index.html"
    response_code        = 200
    error_caching_min_ttl = 60
  }

  default_cache_behavior {
    cache_policy_id          = aws_cloudfront_cache_policy.app_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.app_origin_request_policy.id
    target_origin_id = local.s3_origin_id

    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = var.environment
    Client = var.client_name
    Project = var.project_name
  }

  viewer_certificate {
    # acm_certificate_arn = aws_acm_certificate.app_cert.arn
    # ssl_support_method = "sni-only"
    cloudfront_default_certificate = true
  }
}