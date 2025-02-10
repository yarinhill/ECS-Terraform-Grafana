resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
  enable_deletion_protection = false
  idle_timeout       = 60
  tags = {
    Name = "${var.project_name}-alb"
  }
}

resource "aws_lb_target_group" "prometheus_tg" {
  name        = "${var.project_name}-prometheus-tg"
  port        = 9090
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }
}

resource "aws_lb_target_group" "grafana_tg" {
  name        = "${var.project_name}-grafana-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path                = "/healthz"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }
}

resource "aws_lb_target_group" "loki_tg" {
  name        = "${var.project_name}-loki-tg"
  port        = 3100
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }
}

resource "aws_lb_listener" "prometheus_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 9090
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus_tg.arn
  }
}

resource "aws_lb_listener" "grafana_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}

resource "aws_lb_listener" "loki_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 3100
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loki_tg.arn
  }
}
