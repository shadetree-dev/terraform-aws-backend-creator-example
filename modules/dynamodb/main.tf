# Minimally provisioned table for handling lock state
resource "aws_dynamodb_table" "tf_state" {
  name           = var.name
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    # The type of the LockID attribute is a string
    type = "S"
  }

  # encrypt the DB with our key
  server_side_encryption {
    enabled     = true
    kms_key_arn = var.kms_key_arn
  }

  # add our mandatory or passed in tags
  tags = var.tags
}