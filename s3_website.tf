locals {
  fqdn = "${var.short_url_subdomain}.${var.short_url_domain}"
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

data "template_file" "thekey_html" {
  template = "${file("${path.module}/thekey.tpl")}"
  vars = {
    the_key = aws_api_gateway_api_key.s3_website_admin_api_key.value
  }
}

resource "aws_s3_bucket_object" "thekey_html" {
  bucket       = "${local.fqdn}"
  key          = "test2.html"
  content      = data.template_file.thekey_html.rendered
  depends_on   = [aws_s3_bucket.s3_website_bucket]
  acl          = "public-read"
  content_type = "text/html; charset=utf-8"
  etag         = "${md5(data.template_file.thekey_html.rendered)}"
}


