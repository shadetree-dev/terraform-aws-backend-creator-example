variable "name" {
  description = "The name you want to give to resources created"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "The KMS key that should be used to encrypt our tables"
  type        = string
}

variable "org_id" {
  description = "The unique ID of your organization"
  type        = string
}

variable "bucket_admin_arns" {
  description = "The list of ARNs allowed to administer the bucket"
  type        = list(string)
}

variable "tags" {
  description = "The tags that should be applied to the resource"
  type        = map(string)
  default     = {}
}