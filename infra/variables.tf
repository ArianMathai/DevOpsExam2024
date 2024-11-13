variable "bucket_name" {
  description = "S3 bucket name for storing images"
  default     = "pgr301-couch-explorers"
}

variable "prefix" {
  type        = string
  description = "Prefix for all resource names"
  default     = "arma008_80"
}