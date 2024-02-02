# get information about our current session
data "aws_caller_identity" "current" {}

# Create a bucket policy to restrict access to specific org role for admin
# and usage by all members of your AWS Organizations org
data "aws_iam_policy_document" "bucket_policy" {
  # statement 1 = OrganizationAccountAccessRole default cross-account admin
  # NOTE that the management account does NOT have this role deployed by default!
  # you should probably avoid creating buckets (or resources in general) in that
  # account anyway, in favor of managed member accounts and delegated admin accounts
  # for specific functions!!!
  statement {
    sid    = "AllowAdminAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.bucket_admin_arns
    }
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.tf_bucket.arn
    ]
  }
  # statement 2 = grant all users in our AWS Organizations basic access to bucket
  # note that while this is a wildcard '*' policy for principals, we restrict
  # access via condition statement; they must be a member of our organization
  statement {
    sid    = "AllowOrgBucketAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetBucketVersioning",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    # grant access to the bucket and its objects for respective s3 actions
    resources = [
      aws_s3_bucket.tf_bucket.arn,
      "${aws_s3_bucket.tf_bucket.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.org_id]
    }
  }
}