provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "UBU_web_server" {
  key_pair_name
  count                  = 2
  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.For_UBU.id]
  user_data              = <<EOF
#!/bin/bash
sudo apt update
sudo apt install apache2
sudo myip='curl http://169.254.169.254/latest/meta-data/local-ipv4'
sudo echo '<h2>UBUWebserver with IP: $myip</h2><br>Bild by Terraform!' > /var/www/html/index.html
sudo service apache2 start
sudo chkconfig apache2 on
EOF
}
resource "aws_instance" "AWS_web_server" {
  count                  = 2
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.For_aws.id]
  user_data              = <<EOF
#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo echo '<h2>UBUWebserver with IP: 111</h2><br>Bild by Terraform!' > /var/www/html/index.html
sudo service httpd start
sudo chkconfig httpd on
EOF
}

resource "aws_security_group" "For_UBU" {
  name        = "ubu_security"
  description = "LS1_ubu_security"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
resource "aws_security_group" "For_aws" {
  name        = "aws_security"
  description = "LS1_aws_security"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
