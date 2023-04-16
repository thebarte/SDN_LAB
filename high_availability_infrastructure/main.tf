resource "aws_launch_template" "lt1" {
  name = "my-launch-template1"
  image_id = var.ami_id
  instance_type = "t2.micro"

  vpc_security_group_ids = [var.security_group_id]
}

resource "aws_autoscaling_group" "asg1" {
  name = "my-asg1"
  desired_capacity = 3
  min_size = 2
  max_size = 3
  launch_template {
    id = aws_launch_template.lt1.id
  }

  vpc_zone_identifier = var.subnets
}

resource "aws_lb" "alb1" {
  name = "my-alb1"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = var.subnets
}

resource "aws_lb_target_group" "tg1" {
  name = "my-tg1"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener" "listener1" {
  load_balancer_arn = aws_lb.alb1.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment1" {
  autoscaling_group_name = aws_autoscaling_group.asg1.id
  alb_target_group_arn = aws_lb_target_group.tg1.arn
}