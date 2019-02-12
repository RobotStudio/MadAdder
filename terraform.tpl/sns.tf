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
      identifiers = ["*"]
    }

    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"

      values = [
        "${aws_lambda_function.{{app_name}}_seconds_notifier.arn}",
        {% for interval, rate in minute_intervals.items() %}
        "${aws_cloudwatch_event_target.{{interval}}_sns}",{% endfor %}
      ]
    }

    resources = ["${aws_sns_topic.{{app_name}}.arn}"]
  }
}

