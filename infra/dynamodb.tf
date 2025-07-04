resource "aws_dynamodb_table" "expenses" {
  name         = "expenses"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "Expense Table"
    Environment = "dev"
  }
}
