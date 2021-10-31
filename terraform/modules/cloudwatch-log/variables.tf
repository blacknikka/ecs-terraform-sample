# application name
variable "cloudwatch_name" {}

# retention
variable "retention_in_days" {
  type        = number
  default     = 0
  description = "retention in days"
}


