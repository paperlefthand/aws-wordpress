resource "aws_lb_target_group" "elb_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/wp-includes/images/blank.gif"
  }
}

resource "aws_lb_target_group_attachment" "elb_tg_attachment_a" {
  target_group_arn = aws_lb_target_group.elb_tg.arn
  target_id        = aws_instance.wordpress_server_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "elb_tg_attachment_c" {
  target_group_arn = aws_lb_target_group.elb_tg.arn
  target_id        = aws_instance.wordpress_server_c.id
  port             = 80
}

resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Allow http to elb"
  vpc_id      = aws_vpc.main.id

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

resource "aws_lb" "elb" {
  name               = "elb-wordpress"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
}

resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = aws_lb.elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.elb_tg.arn
    type             = "forward"
  }
}
