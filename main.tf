module "kms" {
  source         = "./modules/kms"
  key_alias      = local.name
  deletion_days  = 30
  org_id         = "o-uj6jmhghvx"
  key_admin_arns = ["arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"]
}

module "s3" {
  source = "./modules/s3"
  # make sure we have our key created first
  depends_on = [module.kms]
}

module "dynamodb" {
  source = "./modules/dynamodb"
  # make sure we have our key created first
  depends_on = [module.kms]
}