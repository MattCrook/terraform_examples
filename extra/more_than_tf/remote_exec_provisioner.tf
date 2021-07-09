terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

# Generate a private key in Terraform.
# In real-world usage, you should manage SSH keys outside of Terraform.
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Pirvate key stored in TF state, not for production, but fine as an exercise. 
resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.example.public_key_openssh
}

# New attribute is key_name - used to instruct AWS to associate your public key with this EC2 instance.
resource "aws_instance" "example" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = aws_key_pair.generated_key.key_name

  provisioner "remote-exec" {
    inline = ["echo \"Hello, World from $(uname -smp)\""]
  }
  # Need to tell Terraform to use SSH to connect to this EC2 instance when running the remote-exec provisioner.
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.example.private_key_pem
  }

}

resource "aws_security_group" "instance" {
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # To make this example easy to try out, we allow all SSH connections.
    # In real world usage, you should lock this down to solely trusted IPs.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

####################################################################################

resource "aws_instance" "webserver" {
    ami                         = "ami-0b2f05cf909299b7c"
    instance_type               = "t2.micro"
    vpc_security_group_ids      = [aws_security_group.allow_all_inbound.id, aws_security_group.allow_all_outbound.id, aws_security_group.allow_ssh.id]
    key_name                    = aws_key_pair.webserver_key.key_name
    associate_public_ip_address = true
    # availability_zone           = "eu-west-3a"
    # subnet_id                   = aws_subnet.publicsubnets.id
    subnet_id                   = aws_subnet.subnet.id
    user_data                   = data.template_file.user_data.rendered
    monitoring                  = true


    # With amazon linux image
     user_data = <<-EOF
         #!/bin/bash
         sudo yum update -y
         sudo yum install httpd -y
         sudo service httpd start
         sudo chkconfig httpd on
         echo "<html><h1>Your terraform deployment worked !!!</h1></html>" | sudo tee /var/www/html/index.html
         hostname -f >> /var/www/html/index.html
         EOF
    # Need to tell Terraform to use SSH to connect to this EC2 instance when running the remote-exec provisioner.
     connection {
         type        = "ssh"
         host        = self.public_ip
         user        = "ec2-user"
         private_key = tls_private_key.webserver_private_key.private_key_pem
         port        = 22
     }

     provisioner "remote-exec" {
         inline = [
             "docker pull mgcrook11/webserver-node-app:1.0",
             "docker run -it -d -p 8080:8080 mgcrook11/webserver-node-app:1.0"
             ]
     }

    tags = {
        env = "dev"
        Name = "webserver"
    }
}
