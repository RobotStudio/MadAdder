# -*- coding: utf-8 -*-

resource "aws_cloudwatch_event_rule" "hatter-interval" {
  count = "${length(var.intervals)}"
  name = "hatter-interval-${count.index}"
  description = "Fires interval: ${element(var.intervals, count.index)}"
  schedule_expression = "${lookup(var.possible, element(var.intervals, count.index))}"
}
