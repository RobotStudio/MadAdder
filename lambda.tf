# -*- coding: utf-8 -*-

resource "aws_lambda_function" "lambda" {
  filename         = "lambda.zip"
  function_name    = "lambda-handler"
  role             = "${aws_iam_role.cloudwatch_alarms_lambda.arn}"
  handler          = "entrypoint.lambda_handler"
  runtime          = "python2.7"
  source_code_hash = "..."

  environment {
    variables {
      env = "${var.stack}"
    }
  }
}
