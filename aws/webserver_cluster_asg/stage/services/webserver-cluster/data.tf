# Configures the web-server cluster code to read the state file from the S3 bucket and folder
# where the database stores it's state.
data "terraform_remote_state" "db" {
    backend = "s3"

    config = {
        bucket = "tf-up-and-running-state-mc"
        key    = "stage/data-stores/mysql/terraform.tfstate"
        region = "us-east-2"
    }
}


data "aws_vpc" "default" {
    # Directs TF to look up the Default VPC in your AWS account.
    default = true
}

# Look up the subnets within your VPC.
data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}
