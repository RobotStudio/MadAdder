variable "aws_region" {
  description = "The chosen region for the application."
  default = "us-east-1"
}

resource "aws_sns_topic" "{{app_name}}" {
  name = "{{app_name}}"
}

output "sns_topic_arn" {
  value = "${aws_sns_topic.{{app_name}}.arn}"
}
provider "aws" {
  region = "${var.aws_region}"
}

# Terraform 0.9.5 suffered from https://github.com/hashicorp/terraform/issues/14399, which causes this template the
# conditionals in this template to fail.
terraform {
  required_version = ">= 0.9.3, != 0.9.5"
  backend "s3" {
    encrypt = true
    bucket = "koralamode-remote-state-storage-s3"
    dynamodb_table = "koralamode-state-lock-dynamo"
    region = "us-east-1"
    key = "hatter-sns.tfstate"
    kms_key_id = "f54f49ea-556f-427d-b24b-90682cc2c04e"
  }
}
