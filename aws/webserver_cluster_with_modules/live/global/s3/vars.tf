variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default     = "tf-up-and-running-locks"
}

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["Brave", "Chrome", "Safari"]
}
