variable "key_alias" {
  description = "The friendly name you want assigned to the KMS key"
  type        = string
}

variable "deletion_days" {
  description = "Schedule KMS key deletion after 7-30 days"
  type        = number
  default     = 30
  validation {
    condition     = var.deletion_days >= 7 && var.deletion_days <= 30
    error_message = "The deletion period must be between 7 and 30 days"
  }
}

variable "org_id" {
  description = "The unique ID of your organization"
  type        = string
}

variable "key_admin_arns" {
  description = "The list of ARNs allowed to administer keys"
  type        = list(string)
}

variable "tags" {
  description = "The tags that should be applied to the resource"
  type        = map(string)
  default     = {}
}