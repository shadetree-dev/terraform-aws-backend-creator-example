# get information about our current session
data "aws_caller_identity" "current" {}


# Create a custom KMS Key Policy document to restrict access
# This will allow us to set the default, admin, and general use policy
data "aws_iam_policy_document" "key_policy" {
  # statement 1 = root user is the key owner; anti-lockout
  statement {
    sid    = "DefaultKeyOwnerPolicy"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = [
      "*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  # statement 2 = key administrator for the creator SSO role
  statement {
    sid    = "KeyAdministratorAccessPolicy"
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = [
      "*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.key_admin_arns
    }
  }
  # statement 3 = grant all users in our AWS Organizations basic access
  statement {
    sid    = "AllowOrganizationAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [var.org_id]
    }
  }
}