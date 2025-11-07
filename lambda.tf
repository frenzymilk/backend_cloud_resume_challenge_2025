/*IAM policy for Lambda execution*/
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
/*IAM policy for CloudWatch logs*/
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role = aws_iam_role.lambda_execution_role.name
}
/*
data "aws_iam_policy_document" "ts_lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.ts_lambda_loggroup.arn,
      "${aws_cloudwatch_log_group.ts_lambda_loggroup.arn}:*"
    ]
  }
}*/

/*IAM role for Lambda execution*/
resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
/*
resource "aws_cloudwatch_log_group" "ts_lambda_loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.counter_lambda.function_name}"
  retention_in_days = 3
}

resource "aws_iam_role_policy" "ts_lambda_role_policy" {
  policy = data.aws_iam_policy_document.ts_lambda_policy.json
  role   = aws_iam_role.lambda_execution_role.id
  name   = "my-lambda-policy"
}*/
/*
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.counter_lambda.function_name
  principal = "apigateway.amazonaws.com"*/
#  source_arn = "${aws_api_gateway_rest_api.visitors_api.execution_arn}/*/*/*"
/*}*/

# Package the Lambda function code
data "archive_file" "counter_code" {
  type        = "zip"
  source_file = "${path.module}/lambda/visitorsCounterFn.py"
  output_path = "${path.module}/lambda/function.zip"
}

# Lambda function
resource "aws_lambda_function" "counter_lambda" {
  filename         = data.archive_file.counter_code.output_path
  function_name    = "visitorsCounterFn"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "index.handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("${data.archive_file.counter_code.output_path}")
}



