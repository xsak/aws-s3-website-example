locals {
  fqdn = "${var.s3_website_subdomain}.${var.s3_website_domain}"
}

resource "aws_s3_bucket" "s3_website_bucket" {
  bucket = "${local.fqdn}"
  acl    = "public-read"
  force_destroy = true
  # depends_on = [aws_s3_bucket.s3_website_logs_bucket]
  # logging {
  #   target_bucket = aws_s3_bucket.s3_website_logs_bucket.id
  #   target_prefix = "log/"
  # }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  
  tags = {
    Project = "s3_website_example"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${local.fqdn}"
  key          = "index.html"
  source       = "index.html"
  depends_on   = [aws_s3_bucket.s3_website_bucket]
  acl          = "public-read"
  content_type = "text/html; charset=utf-8"
  etag         = "${filemd5("index.html")}"

  tags = {
    Project = "s3_website_example"
  }

}

resource "aws_s3_bucket_object" "redirect_url" {
  bucket       = "${local.fqdn}"
  key          = "Rekettyebokor"
  depends_on   = [aws_s3_bucket.s3_website_bucket]
  acl          = "public-read"
  content_type = "text/html; charset=utf-8"
  website_redirect = "http://xsak.hu/nevnap"
  etag         = "${filemd5("index.html")}"

  tags = {
    Project = "s3_website_example"
  }

}

data "aws_route53_zone" "zone_fors3_bucket" {
  name = var.s3_website_domain
}

resource "aws_route53_record" "route53_for_s3_bucket" {
  zone_id    = data.aws_route53_zone.zone_fors3_bucket.zone_id
  name       = local.fqdn
  type       = "A"
  depends_on = [ aws_s3_bucket.s3_website_bucket ]

  alias {
      name    = aws_s3_bucket.s3_website_bucket.bucket_domain_name
      zone_id = aws_s3_bucket.s3_website_bucket.hosted_zone_id
      evaluate_target_health = false
  }
}
