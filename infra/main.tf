
# main.tf - SQS Queue and DLQ
resource "aws_sqs_queue" "dlq" {
  name = "${var.prefix}_image_processing_dlq"
}

resource "aws_sqs_queue" "main_queue" {
  name                      = "${var.prefix}_image_processing_queue"
  delay_seconds             = 0
  max_message_size         = 262144
  message_retention_seconds = 345600
  visibility_timeout_seconds = 30
  receive_wait_time_seconds = 20

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.prefix}_lambda_exec_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Custom policy for S3, bedrock and SQS access
resource "aws_iam_role_policy" "lambda_s3_sqs_policy" {
  name = "${var.prefix}_lambda_s3_sqs_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::pgr301-couch-explorers/80/images/*",
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        "Resource": aws_sqs_queue.main_queue.arn
      },
      {
        "Effect": "Allow",
        "Action": "bedrock:InvokeModel",
        "Resource": "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
      }
    ]
  })
}

# Attach basic Lambda execution role (for CloudWatch logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "image_processor" {
  function_name = "${var.prefix}_image_processor"
  runtime       = "python3.12"
  handler       = "lambda_sqs.lambda_handler"
  role         = aws_iam_role.lambda_exec_role.arn
  filename     = "../lambda_function_sqs_payload.zip"

  memory_size   = 512
  timeout       = 300

  environment {
    variables = {
      LOG_LEVEL = "DEBUG"
      BUCKET_NAME = var.bucket_name
    }
  }
}

# SQS Event Source Mapping for Lambda
resource "aws_lambda_event_source_mapping" "sqs_lambda_trigger" {
  event_source_arn = aws_sqs_queue.main_queue.arn
  function_name    = aws_lambda_function.image_processor.function_name
  batch_size       = 1
}

# Create zip file from Python code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda_sqs.py"
  output_path = "${path.module}/../lambda_function_sqs_payload.zip"
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "image_processor_logs" {
  name              = "/aws/lambda/${var.prefix}_image_processor"
  retention_in_days = 7
}

# Outputs
output "sqs_queue_url" {
  value = aws_sqs_queue.main_queue.url
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.main_queue.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.image_processor.function_name
}