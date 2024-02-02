output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table created for state lock"
  value       = aws_dynamodb_table.tf_state.arn
}