variable "aws_region" {
  description = "The chosen region for the application."
  default = "us-east-1"
}

variable "possible" {
  type = "map"
  description = "Modify possible intervals to add your own"
  default = {
    minutes-5 = "rate(5 minutes)"
    minutes-3 = "rate(3 minutes)"
    minute-1 = "rate(1 minute)"
    seconds-20 = "rate(20 seconds)"
    seconds-5 = "rate(5 seconds)"
  }
}

variable "intervals" {
  type = "map"
  description = "The map of actual intervals that we want to implement"
  default = {
    minutes-5 = 1
    minutes-3 = 1
    minute-1 = 1
    seconds-20 = 1
    seconds-5 = 1
  }
}
