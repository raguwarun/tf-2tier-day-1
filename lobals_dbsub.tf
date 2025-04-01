# create ALB, TG, DB Subnet Group
resource "aws_db_subnet_group" "two-tier-db-sub" {
  subnet_ids = [aws_subnet.two-tier-pvt-sub-1.id,aws_subnet.two-tier-pvt-sub-2.id]
  name="two-tier-db-sub"
}

resource "aws_lb" "two-tier-lb" {
  name="two-tier-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.two-tier-alb-sg.id]
  subnets = [aws_subnet.two-tier-pub-sub-2.id,aws_subnet.two-tier-pub-sub-1.id]

  tags={
    Name="two-tier-lb"
  }
}

resource "aws_lb_target_group" "two-tier-lb-tg" {
  name="two-tier-lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.two-tier-vpc.id
}

resource "aws_lb_listener" "two-tier-lb-listener" {
  load_balancer_arn = aws_lb.two-tier-lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.two-tier-lb-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "two-tier-lg-attach-1" {
  target_group_arn = aws_lb_target_group.two-tier-lb-tg.arn
  target_id        = aws_instance.two-tier-web-1.id
  port =80
}

resource "aws_lb_target_group_attachment" "two-tier-lg-attach-2" {
  target_group_arn = aws_lb_target_group.two-tier-lb-tg.arn
  target_id        = aws_instance.two-tier-web-2.id
  port = 80
}