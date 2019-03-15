resource "aws_iam_role_policy" "lambda_role_policy" {
  name = "lambda_role_policy"
  role = "${aws_iam_role.lambda_iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "cloudfront_invalidation" {
  filename         = "${path.module}/lambda/cloudfrontInvalidation.zip"
  function_name    = "cloudfront_invalidation"
  role             = "${aws_iam_role.lambda_iam_role.arn}"
  handler          = "cloudfrontInvalidation.lambda_handler"
  runtime          = "python3.6"
}

resource "aws_lambda_permission" "allow_execution_from_bucket" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.cloudfront_invalidation.arn}"
    principal = "s3.amazonaws.com"
    source_arn = "${aws_s3_bucket.module.arn}"
}