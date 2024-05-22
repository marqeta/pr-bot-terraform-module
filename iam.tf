data "aws_iam_policy_document" "ecr_read" {
  statement {
    sid = "ECRLogin"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "ECRPullPermsiions"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = [var.opa_bundle_ecr_repo_arn]
    effect    = "Allow"
  }

}

resource "aws_iam_policy" "ecr_read" {
  name        = "ecr_pr_bot_read"
  path        = "/"
  description = "IAM policy for pulling opa bundles from ECR"
  policy      = data.aws_iam_policy_document.ecr_read.json
  tags        = var.tags
}

data "aws_iam_policy_document" "secrets_read" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = var.irsa_secrets_arns
    effect    = "Allow"
  }

  statement {
    actions   = ["secretsmanager:ListSecrets"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "eks_pr_bot_secrets_read" {
  name        = "eks_pr_bot_secrets_read"
  path        = "/"
  description = "IAM policy for reading /ci/pr-bot/* secrets"
  policy      = data.aws_iam_policy_document.secrets_read.json
  tags        = var.tags
}

data "aws_iam_policy_document" "ddb_policy" {
  statement {
    actions = [
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]

    resources = [aws_dynamodb_table.config_table.arn]

    effect = "Allow"
  }

  statement {
    actions = [
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWrite*",
      "dynamodb:Delete*",
      "dynamodb:Update*",
      "dynamodb:PutItem"
    ]

    resources = [aws_dynamodb_table.throttle_table.arn]

    effect = "Allow"
  }

  statement {
    actions = [
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:List*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWrite*",
      "dynamodb:Delete*",
      "dynamodb:Update*",
      "dynamodb:PutItem"
    ]

    resources = [aws_dynamodb_table.evaluation_history_table.arn]

    effect = "Allow"
  }

  statement {
    actions = [
      "dynamodb:Describe*",
      "dynamodb:Get*",
      "dynamodb:PutItem",
      "dynamodb:Update*",
      "dynamodb:Delete*",
      "dynamodb:List*"
    ]

    resources = [aws_dynamodb_table.pr_reviews_lock_table.arn]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "ddb_policy" {
  name   = "pr-bot-${var.environment}-dynamodb-policy"
  policy = data.aws_iam_policy_document.ddb_policy.json
  tags   = var.tags
}

module "eks_pr_bot_irsa" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/irsa?ref=v4.27.0"

  create_kubernetes_namespace       = false
  create_kubernetes_service_account = false
  eks_cluster_id                    = var.eks_cluster_id
  eks_oidc_provider_arn             = var.eks_oidc_provider_arn #
  irsa_iam_policies                 = [aws_iam_policy.eks_pr_bot_secrets_read.arn, aws_iam_policy.ddb_policy.arn, aws_iam_policy.ecr_read.arn]
  irsa_iam_role_name                = var.irsa_iam_role_name
  kubernetes_namespace              = var.k8s_namespace
  kubernetes_service_account        = var.k8s_service_account
  tags                              = var.tags
  irsa_iam_permissions_boundary     = var.irsa_iam_permissions_boundary
}
