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

variable "give_brave_cloudwatch_full_access" {
  description = "If true, brave gets full access to CloudWatch"
  type        = bool
}

variable "policy_name_prefix" {
  description = "The prefix to use for the IAM policy names"
  type        = string
  default     = ""
}
