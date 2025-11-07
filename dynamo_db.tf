resource "aws_dynamodb_table" "visitors_db" {
  name = "visitorsCounter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

}

resource "aws_dynamodb_table_item" "count_item" {
  table_name = aws_dynamodb_table.visitors_db.name
  hash_key   = aws_dynamodb_table.visitors_db.hash_key
  item = <<ITEM
{
  "id": {"S": "vCount"},
  "counter": {"N": "2"},
  "timestamp": {"S": ""}
}
ITEM
}

data "aws_iam_policy_document" "visitors_db_policy_document" {
  statement {
    sid    = "AllowLambdaReadWriteAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda_execution_role.arn]
    }

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]

    resources = [
      "${aws_dynamodb_table.visitors_db.arn}"
    ]

  }
}
