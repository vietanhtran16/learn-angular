module "shell-settings-cdn" {
  source = "./modules/cdn"
  aws_region = "${var.aws_region}"
  environment = "${var.environment}"
  route53_hosted_zone_id = "${var.route53_hosted_zone_id}"
  cloudfront_sub_domain = "${var.cloudfront_sub_domain}"
  bucket_name_prefix = "${var.bucket_name_prefix}"
  providers = {
    aws.virginia = "aws.virginia"
  }
}

module "cognito-user-pool" {
  source = "./modules/cognito"
  user_pool_name = "viet-user-pool"
}