data "aws_iam_policy_document" "lambda_allow_asume_policy" {
  statement {
    actions = [ "sts:AssumeRole", ]
    principals {
      type = "Service"
      identifiers = [ "lambda.amazonaws.com", ]
    }
    principals {
      identifiers = [ "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/flrnks", ]
      type = "AWS"
    }
  }
}

resource "aws_iam_role" "aws_custom_role_for_lambda" {
  name               = "Base-Lambda-Custom-Role"
  description        = "Role that allowed to be assumed by AWS Lambda, which will be taking all actions."
  assume_role_policy = data.aws_iam_policy_document.lambda_allow_asume_policy.json
}

resource "aws_iam_role_policy_attachment" "Allow_Lambda_to_send_CW_Logs" {
  role       = aws_iam_role.aws_custom_role_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "lambda_mock_datasource" {
  role             = aws_iam_role.aws_custom_role_for_lambda.arn
  handler          = "lambda.handler"
  runtime          = "python3.8"
  filename         = var.lambda_func_path
  function_name    = "lambda"
  timeout          = 20
  source_code_hash = filebase64sha256(var.lambda_func_path)
}