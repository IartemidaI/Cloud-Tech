provider "aws" {
  region     = "eu-north-1"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "Terraform_Instance" {
  count                  = 1
  ami                    = "ami-0ed17ff3d78e74700"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.StandartWeb.id]
  key_name               = "key"

  tags = {
    Name    = "Created using terraform"
    Owner   = "Vitaliy"
    Project = "Exam"
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("key.pem")
    host     = self.public_ip
  }


 provisioner "remote-exec" {
    inline = [
      "sudo yum install http -y",
      "sudo yum install php -y",
      "sudo systemctl start httpd",
      "sudo systemctl start php",
      "cd /var/www/html",
      "sudo wget https://wordpress.org/latest.zip",
      "sudo unzip latest.zip"
    ]
  }
}
resource "aws_security_group" "StandartWeb" {
  name        = "StandartWeb SG"
  description = "Allow 22, 80, 8080 inbound traffic"

  ingress {
    description = "Allow 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
