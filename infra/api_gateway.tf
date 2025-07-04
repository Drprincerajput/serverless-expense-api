resource "aws_api_gateway_rest_api" "expense_api" {
  name        = "ExpenseAPI"
  description = "API Gateway for Expense Tracker"
}

resource "aws_api_gateway_resource" "expenses" {
  rest_api_id = aws_api_gateway_rest_api.expense_api.id
  parent_id   = aws_api_gateway_rest_api.expense_api.root_resource_id
  path_part   = "expenses"
}

resource "aws_api_gateway_method" "get_expenses" {
  rest_api_id   = aws_api_gateway_rest_api.expense_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_expense" {
  rest_api_id   = aws_api_gateway_rest_api.expense_api.id
  resource_id   = aws_api_gateway_resource.expenses.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.expense_api.id
  resource_id             = aws_api_gateway_resource.expenses.id
  http_method             = aws_api_gateway_method.get_expenses.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.expense_handler.invoke_arn
}

resource "aws_api_gateway_integration" "post_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.expense_api.id
  resource_id             = aws_api_gateway_resource.expenses.id
  http_method             = aws_api_gateway_method.post_expense.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.expense_handler.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.expense_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.expense_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deploy" {
  depends_on = [
    aws_api_gateway_integration.get_lambda,
    aws_api_gateway_integration.post_lambda
  ]

  rest_api_id = aws_api_gateway_rest_api.expense_api.id
}

resource "aws_api_gateway_stage" "dev_stage" {
  deployment_id = aws_api_gateway_deployment.api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.expense_api.id
  stage_name    = "dev"
}
