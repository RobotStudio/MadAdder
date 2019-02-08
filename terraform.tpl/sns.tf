resource "aws_sns_topic" "{{app_name}}" {
  name = "{{app_name}}"
}

resource "aws_sns_topic_policy" "{{app_name}}" {
  arn = "${aws_sns_topic.{{app_name}}.arn}"
  policy = "${data.aws_iam_policy_document.sns_{{app_name}}.json}"
}

data "aws_iam_policy_document" "sns_{{app_name}}" {
  statement {
    effect = "Allow",
    actions = ["SNS:Publish"]
    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    resources = ["${aws_sns_topic.{{app_name}}.arn}"]
  }
}

