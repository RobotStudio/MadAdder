data "archive_file" "{{app_name}}_function" {
  type = "zip"
  source_file = "${path.module}/app.py"
  output_path = "${path.module}/function.zip"
}

resource "aws_lambda_function" "{{app_name}}_seconds_notifier" {
  function_name = "{{app_name}}_seconds_notifier"
  handler = "app.handler"
  runtime = "python3.6"
  filename = "function.zip"
  #source_code_hash = "${base64sha256(file("function.zip"))}"
  role = "${aws_iam_role.{{app_name}}_lambda_exec_role.arn}"
}

resource "aws_cloudwatch_event_target" "{{app_name}}_lambda" {
  target_id = "{{app_name}}_lambda"
  rule = "${aws_cloudwatch_event_rule.{{app_name}}_seconds_notifier.name}"
  arn = "${aws_lambda_function.{{app_name}}_seconds_notifier.arn}"
}

resource "aws_lambda_permission" "{{app_name}}_seconds_notifier" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.{{app_name}}_seconds_notifier.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.{{app_name}}_seconds_notifier.arn}"
}
