output "s3_bucket_arn" {
  description = "The ID (name) of the bucket created"
  value       = aws_s3_bucket.tf_bucket.arn
}