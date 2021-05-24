# Every TF resource has a meta-parameter called count. Simple Iteration contruct, simply defines
# how many copis of the resouce to create.
# Access count.index (like arr[i]) to give each name or iteration a different name.
# resource "aws_iam_user" "example_iam" {
# count = 3
# name  = "Brave${count.index}"
# }

# This is a better way, saying count is the length of the array "user_names"
# and name is each index of the array at variable "user_names"
resource "aws_iam_user" "example_iam" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

# using for_each -- covert to set because for_each only supports sets and maps when used on a resource.
# Access each value of current item in loop with each.value.
# After terraorm plan, this will output the keys and values, the keys being the keys in for_each (names) and the values being the outputs for that resource.
// resource "aws_iam_user" "example_iam" {
//     for_each = toset(var.user_names)
//     name     = each.value
// }


# IAM policy that allows read-only access to Cloudwatch
resource "aws_iam_policy" "cloudwatch_read_only" {
    name   = "${var.policy_name_prefix}cloudwatch-read-only"
    policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

# What if we wanted to give one of the users in the array from aws_iam_user.example_iam access to cloudwatch as well,
# But allow the person applying the TF configurations to decide whether Brave is assigned only read or both read/write.

resource "aws_iam_policy" "cloudwatch_full_access" {
    name   = "${var.policy_name_prefix}cloudwatch-full-access"
    policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

# Goal is to attach this IAM policy to the user "Brave" based on the value of the input variable give_brave_cloudwatch_full_access.
# Contrived example, but these two resources act like an if/else clause.
# The first attached the IAM policy if var.give_brave_cloudwatch_full_access is true, otherwise does not create it.
# And the second attatches the IAM policy if var.brave_cloudwatch_read_only is true, otherwise does not create it.
# Works well if TF doesn't need to kno which policy is allied, but does NOT work if you need an output based on which was applied.
# For example, if we needed to execute 2 or offer 2 different user-data scripts.
resource "aws_iam_user_policy_attachment" "brave_cloudwatch_full_access" {
  count = var.give_brave_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.example_iam[0].name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_user_policy_attachment" "brave_cloudwatch_read_only" {
  count = var.give_brave_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.example_iam[0].name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}
