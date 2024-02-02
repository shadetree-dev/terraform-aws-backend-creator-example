locals {
  # normalize or set the name; either it is valid
  # and we normalize it by using lower(), or if it is blank
  #  we will be using by a pseudo-random last 12 of UUID mixed with prefix
  uuid = uuid()
  name = var.name != "" ? lower(var.name) : "terraform-backend-${substr(local.uuid, length(local.uuid), -12, 12)}"
}