provider "aws" {
  region = var.aws_region 
  profile = var.aws_profile
}

locals {
  s3_origin_id = "${var.project_name}-s3-origin"
  local_dist_filepath = "../dist"
  s3_public_folder = "public"

  mime_types = {
    ".html" = "text/html"
    ".css" = "text/css"
    ".js" = "application/javascript"
    ".ico" = "image/vnd.microsoft.icon"
    ".jpeg" = "image/jpeg"
    ".png" = "image/png"
    ".svg" = "image/svg+xml"
  }
}