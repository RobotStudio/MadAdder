# Minutes
{% for interval, rate in minute_intervals.items() %}
resource "aws_cloudwatch_event_rule" "{{interval}}" {
  name = "{{interval}}"
  description = "{{rate}}"
  schedule_expression = "{{rate}}"
}

resource "aws_cloudwatch_event_target" "{{interval}}_sns" {
  rule      = "${aws_cloudwatch_event_rule.{{interval}}.name}"
  target_id = "SendToSNS"
  arn       = "${aws_sns_topic.{{app_name}}_{{interval}}.arn}"
}
{% endfor %}

# Seconds
resource "aws_cloudwatch_event_rule" "{{app_name}}_seconds_notifier" {
  name = "{{app_name}}_seconds_notifier"
  description = "rate(1 minute)"
  schedule_expression = "rate(1 minute)"
  depends_on = ["aws_lambda_function.{{app_name}}_seconds_notifier"]
}
