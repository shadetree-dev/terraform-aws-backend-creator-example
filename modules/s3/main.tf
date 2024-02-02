# module "kms" {
#   source = "./modules/kms"
# }

# module "s3" {
#   source = "./modules/s3"
#   # make sure we have our key created first
#   depends_on = [module.kms]
# }

# module "dynamodb" {
#   source = "./modules/dynamodb"
#   # make sure we have our key created first
#   depends_on = [module.kms]
# }