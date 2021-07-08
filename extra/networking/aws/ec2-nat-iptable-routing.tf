terraform {
    required_version = ">= 0.12"
}

resource "aws_vpc" "fairwinds_code_challenge_vpc" {
    cidr_block           = var.main_vpc_cidr
    instance_tenancy     = "default"
    enable_dns_support   = true
    enable_dns_hostnames = true
}


resource "aws_internet_gateway" "IGW" {
    vpc_id =  aws_vpc.fairwinds_code_challenge_vpc.id
}

# Create a Public Subnets.
resource "aws_subnet" "publicsubnets" {
    vpc_id     =  aws_vpc.fairwinds_code_challenge_vpc.id
    cidr_block = "${var.public_subnets}"
}

resource "aws_subnet" "privatesubnets" {
    vpc_id     =  aws_vpc.fairwinds_code_challenge_vpc.id
    cidr_block = "${var.private_subnets}"
}

# Route table for Public Subnet's
resource "aws_route_table" "PublicRT" {
    vpc_id =  aws_vpc.fairwinds_code_challenge_vpc.id

    route {
        # Traffic from Public Subnet reaches Internet via Internet Gateway
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW.id
    }
}

# Route table for Private Subnet's
resource "aws_route_table" "PrivateRT" {
    vpc_id = aws_vpc.fairwinds_code_challenge_vpc.id

    route {
        # Traffic from Private Subnet reaches Internet via NAT Gateway
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.NATgw.id
    }
}


# Route table Association with Public Subnet's
resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id      = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }


# Route table Association with Private Subnet's
resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id      = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
}

resource "aws_eip" "nateIP" {
    vpc        = true
    instance   = aws_instance.webserver.id
    depends_on = [aws_internet_gateway.IGW]
}

# Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
    allocation_id = aws_eip.nateIP.id
    subnet_id     = aws_subnet.publicsubnets.id
    depends_on    = [aws_internet_gateway.IGW]
}


######################### Defualt VPC ########################

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.gw]
}
