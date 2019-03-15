output "bucket_name" {
    value = "${aws_s3_bucket.module.bucket}"
}

output "cloudfront_id" {
    value = "${aws_cloudfront_distribution.cloudfront.id}"
}