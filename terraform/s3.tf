resource "aws_s3_bucket" "app_bucket" {
  bucket = "${var.project_name}-${var.environment}"
  
  tags = {
    Environment = var.environment
    Client = var.client_name
  }
}

resource "aws_s3_bucket_cors_configuration" "app_cors" {
  bucket = aws_s3_bucket.app_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    # allowed_origins = ["https://${aws_cloudfront_distribution.app_distribution.domain_name}"]
     allowed_origins = ["https://${var.domain_name}"]
  }
}

resource "aws_s3_bucket_policy" "app_bucket_policy" {
  bucket = aws_s3_bucket.app_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "PolicyForCloudFrontPrivateContent",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com",
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.app_bucket.arn}/${local.s3_public_folder}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.app_distribution.arn,
          },
        },
      },
      {
        Effect   = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com",
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.app_bucket.arn}/cloudfront-logs/*",
      },
    ],
  })
}

resource "aws_s3_object" "cloudfront_logs_folder" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "cloudfront-logs/"
  acl    = "private"
}

resource "aws_s3_object" "app_files" {
  for_each = fileset(local.local_dist_filepath, "**")
  bucket   = aws_s3_bucket.app_bucket.id
  key      = "${local.s3_public_folder}/${each.key}"
  source   = "${local.local_dist_filepath}/${each.value}"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
  etag     = filemd5("${local.local_dist_filepath}/${each.value}")
}