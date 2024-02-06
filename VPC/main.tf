resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr

  tags = {
      Name = "GMR-2024-vpc"
    }
  
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
      Name = "GMR-2024-IGW"
    }
  
}

resource "aws_subnet" "pub" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
      Name = "GMR-2024-PUB"
    }
  
}

resource "aws_route_table" "pub_route"{
  vpc_id = aws_vpc.vpc1.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
      Name = "GMR-2024-pub_route"
    }

}

resource "aws_route_table_association" "arts" {
  subnet_id = aws_subnet.pub.id
  route_table_id = aws_route_table.pub_route.id
  
}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.vpc1.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "GMR-2024-sg"
    }
  
}
resource "tls_private_key" "ec2_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "webapplication"
  public_key = tls_private_key.ec2_ssh.public_key_openssh
}

resource "local_file" "tf-key" {
  content  = tls_private_key.ec2_ssh.private_key_pem
  filename = "webapplication-raj.pem"
}
