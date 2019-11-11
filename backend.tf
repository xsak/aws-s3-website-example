terraform {
  backend "s3" {
    bucket = "xsak-trf"
    key    = "aws-s3-website-example/terraform.tfstate"
    region = "eu-north-1"
  }
}
