variable "region" {
  default     = "eu-north-1"
  description = "The AWS region to use for the Short URL project."
}

variable "s3_website_domain" {
  type        = string
  description = "The top domain name to use for short URLs."
}

variable "s3_website_subdomain" {
  type        = string
  description = "The subdomain under s3_website_domain."
}
