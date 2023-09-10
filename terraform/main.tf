resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = file("../ec2_key_pair/deployer_key.pub")
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[0]
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[1]
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public.id
}



resource "aws_eip" "nat_eip_a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_a" {
  subnet_id     = aws_subnet.public_subnet_a.id
  allocation_id = aws_eip.nat_eip_a.id
}

resource "aws_eip" "nat_eip_c" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_c" {
  subnet_id     = aws_subnet.public_subnet_c.id
  allocation_id = aws_eip.nat_eip_c.id
}


resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[0]
  availability_zone = "ap-northeast-1a"
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_1a.id
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_c.id
  }
}

resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[1]
  availability_zone = "ap-northeast-1c"
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_1c.id
}

resource "aws_instance" "bastion_host" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_a.id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "app_server_a" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_a.id
  key_name               = aws_key_pair.deployer.key_name
  user_data              = file("../scripts/setup.sh")

  tags = {
    Name = "App Server A"
  }

}

resource "aws_instance" "app_server_c" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_c.id
  key_name               = aws_key_pair.deployer.key_name
  user_data              = file("../scripts/setup.sh")

  tags = {
    Name = "App Server C"
  }

}

resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
