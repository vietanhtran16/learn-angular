variable "aws_region" {}
variable "environment" {
    description = "Either dev or prod"
}
variable "route53_hosted_zone_id" {}
variable "cloudfront_sub_domain" {}
variable "bucket_name_prefix" {}