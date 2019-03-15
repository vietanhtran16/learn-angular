resource "aws_acm_certificate" "cert" {
  domain_name = "${local.cloudfront_full_domain_name}"
  validation_method = "DNS"
  provider = "aws.virginia"
  lifecycle {
    create_before_destroy = true
  }

  tags = "${local.common_tags}"
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${local.cloudfront_full_domain_name}", "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"]
  provider = "aws.virginia"
}

resource "aws_route53_record" "cert_validation_domain" {
  zone_id = "${var.route53_hosted_zone_id}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  ttl     = "300"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
}