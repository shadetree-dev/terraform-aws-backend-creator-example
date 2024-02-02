# We get the outputs from child modules and print them for funsies

output "s3_bucket_arn" {
  description = "The ID (name) of the bucket created"
  value       = module.s3.s3_bucket_arn
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table created for state lock"
  value       = module.dynamodb.dynamodb_table_arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key created for encrypting our resources"
  value       = module.kms.kms_key_arn
}