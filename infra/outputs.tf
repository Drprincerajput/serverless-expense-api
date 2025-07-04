output "api_url" {
  value = "https://${aws_api_gateway_rest_api.expense_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev_stage.stage_name}/expenses"
  description = "Base URL for Expense API"
}
