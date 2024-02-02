# Local module to create a KMS key for use with S3 + DynamoDB
# you could also look at using the public AWS module if you want
# to pass parameters to that instead: 
# https://registry.terraform.io/modules/terraform-aws-modules/kms/aws/latest
module "kms" {
  source = "./modules/kms"
  # consistent naming for resources normalized in locals.tf
  key_alias = local.name
  # this is the default anyway; you can set between 7-30
  deletion_days = 30
  # re-use dynamic lookup from data.tf
  org_id = local.org_id
  # get the combined ARNs for static + SSO users we want
  key_admin_arns = local.admin_arns
  # standard set of tags defined in locals.tf
  tags = local.tags
}

# Local module to create a new S3 bucket for storing our Terraform State
# you could also look at the public AWS module if you want
# to pass parameters to that instead:
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest
module "s3" {
  source = "./modules/s3"
  # make sure we have our key created first
  depends_on = [module.kms]
  # consistent naming for resources normalized in locals.tf
  name = local.name
  # re-use dynamic lookup from data.tf
  org_id = local.org_id
  # list of roles allowed admin access
  bucket_admin_arns = local.admin_arns
  # use our created KMS key
  kms_key_arn = module.kms.kms_key_arn
  # standard set of tags defined in locals.tf
  tags = local.tags
}

# Local module to create a basic DynamoDB table for Terraform State Lock
# NOTE that this resource does not support resource policy definition
# like KMS + S3 do; managing access outside your account becomes difficult
# so you will need to make sure users have access to the account where 
# this resource is deployed through an IAM Role; otherwise you could use
# '-lock=false' if testing with Terraform to bypass this
module "dynamodb" {
  source = "./modules/dynamodb"
  # make sure we have our key created first
  depends_on = [module.kms]
  # same name as other resources, but set suffix to know it is for lock
  name = "${local.name}-lock"
  # use our created KMS key
  kms_key_arn = module.kms.kms_key_arn
  # standard set of tags defined in locals.tf
  tags = local.tags
}