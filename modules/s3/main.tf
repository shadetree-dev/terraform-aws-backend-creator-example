# simply create a bucket with our name!
# NOTE: buckets are globally unique, so make sure it is not taken
resource "aws_s3_bucket" "tf_bucket" {
  bucket = var.name
  tags   = var.tags

  # set timeout, because it SHOULD create quickly; something up if not 
  timeouts {
    create = "1m"
  }
}

# Block public access unless you are CERTAIN you want it to be public accessible
# https://aws.amazon.com/s3/features/block-public-access/
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tf_bucket.id

  # set to true for all options
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# see data.tf for access granted
resource "aws_s3_bucket_policy" "tf_access_policy" {
  bucket = aws_s3_bucket.tf_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

# enable versioning, so that you have some ability to retrieve 
# changed state files
resource "aws_s3_bucket_versioning" "tf_bucket" {
  bucket = aws_s3_bucket.tf_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}