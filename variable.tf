variable "k8s_service_name" {
  type        = string
  description = "Name of the K8s service object of pr-bot. Used to retrieve data about aws resources created by k8s controllers."
}

variable "k8s_namespace" {
  type        = string
  description = "Name of the K8s service object of pr-bot. Used to retrieve data about aws resources created by k8s controllers."
}

variable "eks_cluster_id" {
  type        = string
  description = "Name of the K8s cluster where pr-bot is deployed. Used to retrieve data about aws resources created by k8s controllers."
}

variable "k8s_service_account" {
  type        = string
  description = "Name of the K8s service account attached with pr-bot."
}

variable "environment" {
  type        = string
  description = "Environment where pr-bot is being deployed"
}

variable "irsa_iam_role_name" {
  type        = string
  description = "Name for the IAM role that will be assumed by the service account"
}

variable "irsa_iam_permissions_boundary" {
  type        = string
  description = "ARN for the IAM permission boundry that will be associated with the IAM role"
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
  type        = map(string)
  default     = {}
}

variable "irsa_secrets_arns" {
  description = "Resource arns(s) of the AWS secrets that the IRSA IAM role will be granted access to"
  type        = list(string)
}

variable "lb_name" {
  type        = string
  description = "Name of the load balancer created by aws load balacner controller"
  default     = ""
}

variable "eks_oidc_provider_arn" {
  description = "EKS OIDC Provider ARN e.g., arn:aws:iam::<ACCOUNT-ID>:oidc-provider/<var.eks_oidc_provider>"
  type        = string
}

variable "vpc_endpoint_allowlist" {
  description = "List of aws account ids to allow list in pr bot vpc endpoint service"
  type        = list(string)
}

variable "opa_bundle_ecr_repo_arn" {
  description = "ARN of the ECR repository where OPA bundles are published"
  type        = string
}
