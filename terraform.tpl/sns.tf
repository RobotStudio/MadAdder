# Minutes topics
{% for interval, rate in minute_intervals.items() %}
resource "aws_sns_topic" "{{app_name}}_{{interval}}" {
  name = "{{app_name}}_{{interval}}"
}

resource "aws_sns_topic_policy" "{{app_name}}_{{interval}}" {
  arn = "${aws_sns_topic.{{app_name}}_{{interval}}.arn}"
  policy = "${data.aws_iam_policy_document.sns_{{app_name}}_{{interval}}.json}"
}

data "aws_iam_policy_document" "sns_{{app_name}}_{{interval}}" {
  policy_id = "Policy1550029269136{{interval}}"
  statement {
    sid = "Stmt1550029261725{{interval}}"
    effect = "Allow"
    actions = ["sns:Publish"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"
      values = ["${aws_cloudwatch_event_target.{{interval}}_sns.arn}"]
    }

    resources = ["${aws_sns_topic.{{app_name}}_{{interval}}.arn}"]
  }

  statement {
    sid = "Stmt1550029496021{{interval}}"
    effect = "Allow",
    actions = ["sns:Subscribe"]
    resources = ["${aws_sns_topic.{{app_name}}_{{interval}}.arn}"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}
{% endfor %}
# Seconds topics
{% for interval, rate in second_intervals.items() %}
resource "aws_sns_topic" "{{app_name}}_{{interval}}" {
  name = "{{app_name}}_{{interval}}"
}

resource "aws_sns_topic_policy" "{{app_name}}_{{interval}}" {
  arn = "${aws_sns_topic.{{app_name}}_{{interval}}.arn}"
  policy = "${data.aws_iam_policy_document.sns_{{app_name}}_{{interval}}.json}"
}

data "aws_iam_policy_document" "sns_{{app_name}}_{{interval}}" {
  policy_id = "Policy1550029269136{{interval}}"
  statement {
    sid = "Stmt1550029261725{{interval}}"
    effect = "Allow"
    actions = ["sns:Publish"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }

    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"
      values = ["${aws_lambda_function.{{app_name}}_seconds_notifier.arn}"]
    }

    resources = ["${aws_sns_topic.{{app_name}}_{{interval}}.arn}"]
  }

  statement {
    sid = "Stmt1550029496021{{interval}}"
    effect = "Allow",
    actions = ["sns:Subscribe"]
    resources = ["${aws_sns_topic.{{app_name}}_{{interval}}.arn}"]

    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}
{% endfor %}
