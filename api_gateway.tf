resource "aws_apigatewayv2_api" "visitors_api" {
  name          = "visitors-counter-http-api"
  protocol_type = "HTTP"
  target        = aws_lambda_function.counter_lambda.arn
  cors_configuration {
    allow_origins = ["https://www.${var.domain_name}", "https://${var.domain_name}"]
    allow_methods = ["GET", "POST", "OPTIONS"]
  }
}

resource "aws_apigatewayv2_route" "post" {
  api_id    = aws_apigatewayv2_api.visitors_api.id
  route_key = "POST /visitorsCounter"
}

resource "aws_apigatewayv2_route" "get" {
  api_id    = aws_apigatewayv2_api.visitors_api.id
  route_key = "GET /visitorsCounter"
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.counter_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.visitors_api.execution_arn}/*/*"
}

# Output the API Gateway URL
output "api_url" {
  value = "${aws_apigatewayv2_api.visitors_api.api_endpoint}"
}