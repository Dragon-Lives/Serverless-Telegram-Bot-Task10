variable "bucket_name" {}
variable "table_name" {}
variable "table_arn" {}
variable "weather_api_key" {}
variable "telegram_token" {}

# 1. Zip the Python code
data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.root}/src/lambda_function.py"
  output_path = "${path.root}/src/lambda.zip"
}

# 2. FIND the existing LabRole (Do not create one)
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# 3. Lambda Function (Using the existing LabRole)
resource "aws_lambda_function" "fn" {
  filename      = data.archive_file.zip.output_path
  function_name = "Task10Bot"
  role          = data.aws_iam_role.lab_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 10
  environment {
    variables = {
      TABLE_NAME      = var.table_name
      BUCKET_NAME     = var.bucket_name
      WEATHER_API_KEY = var.weather_api_key
      TELEGRAM_TOKEN  = var.telegram_token
    }
  }
}

# 4. API Gateway (Public URL)
resource "aws_apigatewayv2_api" "api" {
  name          = "bot-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "int" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.fn.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /bot"
  target    = "integrations/${aws_apigatewayv2_integration.int.id}"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "perm" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fn.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*/bot"
}

output "api_endpoint" {
  value = "${aws_apigatewayv2_api.api.api_endpoint}/bot"
}