provider "aws" {
    profile = "default"
    region = "eu-west-1"
}

# resource "aws_s3_bucket" "s3_bucket_serverless-fastapi" {
#   bucket = "serverless-fastapi"
#   acl    = "private"

#   tags = {
#     Name        = "serverless-fastapi"
#     Environment = "/api/v1"
#   }
# }

# resource "aws_s3_bucket_object" "s3-object" {
#   bucket = aws_s3_bucket.s3_bucket_serverless-fastapi.id
#   key = "function.zip"
#   source = "function.zip"
# }


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda-serverless-fastapi" {
  filename      = "../function.zip"
  function_name = "serverless-fastapi"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "app.main.handler"

  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("../function.zip")

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }

  }
  tags = {
    Name        = "serverless-fastapi"
    Environment = "/api/v1"
  }
}