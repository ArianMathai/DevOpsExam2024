variable "bucket_name" {
  description = "S3 bucket name for storing images"
  default     = "pgr301-couch-explorers"
}

variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "arma008_80"
}

variable "notification_email" {
  description = "Email address to receive alarm notifications"
  type        = string
  default     = "arian.mathai@gmail.com"
}

variable "threshold" {
  description = "threshold for sns alarm to trigger"
  type        = string
  default     = "1"
}