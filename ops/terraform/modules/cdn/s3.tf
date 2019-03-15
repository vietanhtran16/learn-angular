resource "aws_s3_bucket" "module" {
  bucket = "${var.bucket_name_prefix}-${var.environment}"
  acl = "private"

  versioning {
      enabled = true
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = "${local.common_tags}"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.module.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "module-policy" {
  bucket = "${aws_s3_bucket.module.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_s3_bucket_notification" "bucket_terraform_notification" {
    bucket = "${aws_s3_bucket.module.id}"
    lambda_function {
        lambda_function_arn = "${aws_lambda_function.cloudfront_invalidation.arn}"
        events = ["s3:ObjectCreated:*"]
    }
}