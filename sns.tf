resource "aws_sns_topic" "cron" {
  name = "sns-cron-topic"
}

resource "aws_sns_topic_subscription" "cron_topic" {
  topic_arn = "${aws_sns_topic.cron.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.interval.arn}"
}

resource "aws_lambda_permission" "interval_to_sns" {
    statement_id = "AllowExecutionFromSNS"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.lambda.arn}"
    principal = "sns.amazonaws.com"
    source_arn = "${aws_sns_topic.topic.arn}"
}

resource "aws_sns_topic_policy" "cron" {
  arn = "${aws_sns_topic.cron.arn}"

  policy = "${data.aws_iam_policy_document.sns_cwon.json}"
}

data "aws_iam_policy_document" "sns_upload" {
  policy_id = "snssqssns"
  statement {
    actions = [
      "SNS:Publish",
    ]
    condition {
      test = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:s3:::${var.aws_s3_bucket_upload_name}",
      ]
    }
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "*"]
    }
    resources = [
      "${aws_sns_topic.upload.arn}",
    ]
    sid = "snssqssnss3upload"
  }
}

