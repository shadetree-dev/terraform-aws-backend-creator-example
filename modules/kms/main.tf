# create a new KMS key, which uses our custom policy from data.tf
resource "aws_kms_key" "tf_key" {
  description = "KMS key for encrypting S3 + DynamoDB resources"
  # secure it up! rotate keys automatically
  enable_key_rotation = true
  # single-region by default
  multi_region = false
  # set a configurable deletion schedule
  deletion_window_in_days = var.deletion_days
  # use a custom key policy for granting access
  policy = data.aws_iam_policy_document.key_policy.json

  # set our tags
  tags = var.tags

  # set timeout, because it SHOULD create quickly; something up if not 
  timeouts {
    create = "1m"
  }
}

# set the alias for the key
resource "aws_kms_alias" "tf_key" {
  name          = "alias/${var.key_alias}"
  target_key_id = aws_kms_key.tf_key.key_id
}