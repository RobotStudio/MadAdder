# -*- coding: utf-8 -*-

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name = "every-five-minutes"
  description = "Fires every five minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_rule" "every_three_minutes" {
  name = "every-three-minutes"
  description = "Fires every three minutes"
  schedule_expression = "rate(3 minutes)"
}

resource "aws_cloudwatch_event_rule" "every_minute_orderbook" {
  name = "every-minute"
  description = "Fires every minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_rule" "every_hour" {
  name = "every-hour"
  description = "Fires every hour"
  schedule_expression = "rate(1 hour)"
}
