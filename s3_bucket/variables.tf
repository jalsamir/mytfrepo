variable "custom_bucket_policy" {
  description = "JSON formatted bucket policy to attach to the bucket."
  type        = "string"
  default     = ""
}
variable "vpc_id" {}