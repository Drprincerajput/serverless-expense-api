variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for storing terraform state"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for terraform state locking"
  type        = string
}
