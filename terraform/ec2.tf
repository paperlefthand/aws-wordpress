resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = file("../ec2_key_pair/deployer_key.pub")
}

resource "aws_instance" "wordpress_server_a" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_a.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.wordpress_server_sg.id]
  associate_public_ip_address = true
  # user_data                   = file("../scripts/setup.sh")

  tags = {
    Name = "Wordpress Server A"
  }

}
resource "aws_instance" "wordpress_server_c" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_c.id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.wordpress_server_sg.id]
  associate_public_ip_address = true
  # user_data                   = file("../scripts/setup.sh")

  tags = {
    Name = "Wordpress Server C"
  }

}
resource "aws_security_group" "wordpress_server_sg" {
  name   = "wordpress_server_sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


