{% for interval, rate in minute_intervals.items() %}
resource "aws_cloudwatch_event_rule" "{{interval}}" {
  name = "{{interval}}"
  description = "{{rate}}"
  schedule_expression = "{{rate}}"
}
{% endfor %}

{% for interval, rate in second_intervals.items() %}
resource "aws_cloudwatch_event_rule" "{{interval}}" {
  name = "{{interval}}"
  description = "{{rate}}"
  schedule_expression = "rate(1 minute)"
}
{% endfor %}
