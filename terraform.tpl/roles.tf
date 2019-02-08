# -*- coding: utf-8 -*-

resource "aws_iam_role" "{{app_name}}_lambda_exec_role" {
	name = "{{app_name}}_lambda_exec_role"
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

resource "aws_iam_policy" "{{app_name}}_lambda_policy" {
  name = "{{app_name}}_lambda_policy"
  description = "IAM list roles, SNS publish, SQS pop, logs, S3, and kinesis"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "events:*",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "iam:ListRoles",
        "iam:PassRole"
      ],
      "Resource": "*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "sns:CreateTopic",
        "sns:Publish"
      ],
      "Resource": "arn:aws:sns:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Resource": [
        "arn:aws:sqs:*:*:*"
      ],
      "Effect": "Allow"
    },
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ],
      "Effect": "Allow"
    },
    {
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3::*:*:*"
      ],
      "Effect": "Allow"
    },
    {
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
      ],
      "Resource": [
        "arn:aws:kinesis:*:*:*"
      ],
      "Effect": "Allow"
    },
    {
      "Action": "firehose:PutRecord",
      "Resource": [
        "arn:aws:firehose:*:*:*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "{{app_name}}_lambda_attachment" {
  role       = "${aws_iam_role.{{app_name}}_lambda_exec_role.name}"
  policy_arn = "${aws_iam_policy.{{app_name}}_lambda_policy.arn}"
}
