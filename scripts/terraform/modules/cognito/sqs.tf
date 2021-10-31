resource "aws_sqs_queue" "user_creation_queue" {
  name                       = "${var.null_label_prefix}-user-creation-queue"
  receive_wait_time_seconds  = 20
  visibility_timeout_seconds = 60
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.user_creation_dead_letter_queue.arn
    maxReceiveCount     = 4
  })
  tags = var.null_label_tags
}

resource "aws_sqs_queue" "user_creation_dead_letter_queue" {
  name                       = "${var.null_label_prefix}-user-creation-dqueue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 604800
  tags                       = var.null_label_tags
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size       = 10
  event_source_arn = aws_sqs_queue.user_creation_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.user_creation.arn
}
