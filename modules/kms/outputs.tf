output "kms_key_arn" {
  description = "The ARN of the KMS key created for encrypting our resources"
  value       = aws_kms_key.tf_key.arn
}