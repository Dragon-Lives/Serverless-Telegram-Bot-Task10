variable "table_name" {}

resource "aws_dynamodb_table" "t" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

output "table_name" {
  value = aws_dynamodb_table.t.name
}

output "table_arn" {
  value = aws_dynamodb_table.t.arn
}