resource "aws_vpc_endpoint_service" "pr-bot" {

  acceptance_required        = false
  network_load_balancer_arns = [data.aws_lb.pr-bot-nlb.arn]
  allowed_principals         = [for id in var.vpc_endpoint_allowlist : "arn:aws:iam::${id}:root"]
  tags                       = var.tags
}
