variable "name" {
  description = "The name you want to give to resources created"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "The KMS key that should be used to encrypt our tables"
  type        = string
}

variable "tags" {
  description = "The tags that should be applied to the resource"
  type        = map(string)
  default     = {}
}