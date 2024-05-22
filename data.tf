data "aws_region" "current" {}

data "aws_lb" "pr-bot-nlb" {
  name = var.lb_name
}
