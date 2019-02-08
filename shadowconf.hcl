# Intervals

minute_intervals = {
  "every_five_minutes" = "rate(5 minutes)"
  "every_three_minutes" = "rate(3 minutes)"
  "every_minute" = "rate(1 minute)"  # required if you have any second_intervals
  "every_hour" = "rate(1 hour)"
}

second_intervals = {
  # Note: If not divisible by 60, then every minute will see timing errors.
  # Luckily, 60 is divisible by most numbers less than 60 and all less than 11.
  "every_twenty_seconds" = "rate(20 seconds)"
  "every_five_seconds" = "rate(5 seconds)"
  "every_three_seconds" = "rate(3 seconds)"
  "every_second" = "rate(1 second)"
}

# Resolves to SNS topic, among other things
app_name = "cron"

# Run shadow fax on terraform.tpl, then terraform apply the generated directory, and
# populate this based on the output.
topic_arn = ""
