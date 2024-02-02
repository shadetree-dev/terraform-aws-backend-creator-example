# get information about our current session
data "aws_caller_identity" "current" {}

# get information about your AWS Organizations organization (redundant much, AWS?)
data "aws_organizations_organization" "my_org" {}

# get our SSO admins, as well, conditionally with a flag
# otherwise lookup might fail and break your plan/apply
data "aws_iam_roles" "sso_roles" {
  count       = var.sso_enabled == true ? 1 : 0
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
  # SET THIS TO YOUR SSO ROLE REGEX PATTERN!
  # NOTE that it will be different per account; the base name is the same
  # but each account gets its own random string appended
  name_regex = ".*Admin*."
}