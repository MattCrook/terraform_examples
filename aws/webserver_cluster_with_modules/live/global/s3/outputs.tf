output "s3_bucket_arn" {
    value       = aws_s3_bucket.tf_state.arn
    description = "The ARN (Amazon Resource Name) of the S3 bucket."
}

output "dynamodb_table_name" {
    value       = aws_dynamodb_table.terraform_locks.name
    description = "The name of the DynamoDB table."
}

output "brave_arn" {
    value       = aws_iam_user.example_iam[0].arn
    description = "The ARN for user Brave"
}
 output "all_arns" {
     value       = aws_iam_user.example_iam[*].arn
     description = "The ARNs for all iam users"
 }
