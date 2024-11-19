output "sns_topic_arn" {
  value = aws_sns_topic.notification_topic.arn
}

output "sqs_queue_url" {
  value = aws_sqs_queue.main_queue.url
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.main_queue.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.image_processor.function_name
}