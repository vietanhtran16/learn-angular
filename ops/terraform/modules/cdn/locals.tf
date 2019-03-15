data "aws_route53_zone" "domain" {
  zone_id = "${var.route53_hosted_zone_id}"
}

locals {
  cloudfront_full_domain_name = "${var.cloudfront_sub_domain == "" ? "" : "${var.cloudfront_sub_domain}." }${substr(data.aws_route53_zone.domain.name, 0, length(data.aws_route53_zone.domain.name) - 1) }"
}