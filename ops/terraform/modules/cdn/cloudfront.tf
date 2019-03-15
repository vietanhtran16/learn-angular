resource "aws_cloudfront_distribution" "cloudfront" {
  enabled = true
  aliases = ["${local.cloudfront_full_domain_name}"]
  price_class = "${var.environment == "prod" ? "PriceClass_All" : "PriceClass_200"}"
  
  origin {
    domain_name = "${aws_s3_bucket.module.bucket_domain_name}"
    origin_id   = "bucket_${aws_s3_bucket.module.bucket}"
    s3_origin_config {
        origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "bucket_${aws_s3_bucket.module.bucket}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn="${aws_acm_certificate.cert.arn}"
    minimum_protocol_version="TLSv1.1_2016"
    ssl_support_method="sni-only"
  }

  tags = "${local.common_tags}"

  depends_on = ["aws_acm_certificate_validation.cert_validation"]
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = "Managed by Terraform - ${aws_s3_bucket.module.bucket}-access-identity"
}

resource "aws_route53_record" "cloudfront_subdomain" {
  zone_id = "${var.route53_hosted_zone_id}"
  name    = "${var.cloudfront_sub_domain}"
  type    = "A"
  alias {
    name                   = "${aws_cloudfront_distribution.cloudfront.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.cloudfront.hosted_zone_id}"
    evaluate_target_health = false
  }
}