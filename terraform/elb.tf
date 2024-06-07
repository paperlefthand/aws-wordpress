resource "aws_lb" "alb" {
  name               = "alb-wordpress"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_c.id]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path = "/wp-includes/images/blank.gif"
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment_a" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.wordpress_server_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment_c" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.wordpress_server_c.id
  port             = 80
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow http to alb"
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


