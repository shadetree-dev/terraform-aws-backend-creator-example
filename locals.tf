locals {
  # we will be using by a pseudo-random last 12 of UUID mixed with prefix if we get no name
  # https://developer.hashicorp.com/terraform/language/functions/uuid
  uuid = uuid()
  # normalize or set the name; either it is valid
  # and we normalize it by using lower(), or if it is blank
  name = var.name != "" ? lower(var.name) : "terraform-backend-${substr(local.uuid, length(local.uuid), -12, 12)}"

  # get your AWS Organizations org ID dynamically and set here for re-use
  org_id = data.aws_organizations_organization.my_org.id

  # Get our SSO roles, supposing we are (hopefully) using SSO!
  sso_roles = tolist(data.aws_iam_roles.sso_roles[0].arns)

  # ARNs for key and bucket administration; created in locals for consistent re-use
  # uses concat() function to merge lists: https://developer.hashicorp.com/terraform/language/functions/concat
  admin_arns = concat(
    local.sso_roles,
    ["arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"]
  )

  # set some standard tags we can pass to resources
  tags = {
    Name       = local.name
    Purpose    = "terraform"
    InspiredBy = "shadetree.dev"
  }
}