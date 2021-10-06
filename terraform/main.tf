provider "aws" {
    profile = "default"
    region = "eu-west-1"
}

# resource "aws_s3_bucket" "s3_bucket_coinfast" {
#   bucket = "coinfast"
#   acl    = "private"

#   tags = {
#     Name        = "coinfast"
#     Environment = "/api/v1"
#   }
# }

# resource "aws_s3_bucket_object" "s3-object" {
#   bucket = aws_s3_bucket.s3_bucket_coinfast.id
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

resource "aws_lambda_function" "coinfast" {
  filename      = "../function.zip"
  function_name = "coinfast"
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
    Name        = "coinfast"
    Environment = "/api/v1"
  }
}


resource "aws_dynamodb_table" "sensors-dynamodb-table" {
  name           = "Sensors"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "transactionId"
  range_key      = "coinId"

  attribute {
    name = "transactionId"
    type = "S"
  }

  attribute {
    name = "transactionDate"
    type = "S"
  }

  attribute {
    name = "coinId"
    type = "S"
  }

  attribute {
    name = "coinName"
    type = "S"
  }

    attribute {
    name = "coinUnities"
    type = "N"
  }

    attribute {
    name = "coinPurchasePrice"
    type = "N"
  }
  
    attribute {
    name = "coinBEP"
    type = "S"
  }

  tags = {
    Name        = "coinfast"
    Environment = "/api/v1"
  }

}