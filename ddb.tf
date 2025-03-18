resource "aws_dynamodb_table" "config_table" {
  name           = "pr-bot-${var.environment}-config"
  hash_key       = "name"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "name"
    type = "S"
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "throttle_table" {
  name           = "pr-bot-${var.environment}-throttle"
  hash_key       = "key"
  range_key      = "time"
  read_capacity  = 40
  write_capacity = 40

  attribute {
    name = "key"
    type = "S"
  }

  attribute {
    name = "time"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "evaluation_history_table" {
  name         = "pr-bot-${var.environment}-evaluation-history"
  hash_key     = "pr"
  range_key    = "delivery_id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "pr"
    type = "S"
  }

  attribute {
    name = "delivery_id"
    type = "S"
  }

  ttl {
    attribute_name = "expire_at"
    enabled        = true
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "pr_reviews_lock_table" {
  name         = "pr-bot-${var.environment}-reviews-lock-table"
  hash_key     = "key"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "key"
    type = "S"
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "datastore_table" {
  name         = "pr-bot-${var.environment}-datastore"
  hash_key     = "pk"
  range_key    = "sk"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  ttl {
    attribute_name = "expire_at"
    enabled        = true
  }

  tags = var.tags
}
