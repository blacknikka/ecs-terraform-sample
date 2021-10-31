# ----------------------
# application
# ----------------------
resource "aws_alb" "app" {
  name            = "elb-for-app-${var.app_name}"
  security_groups = [aws_security_group.load_balancers_ecs.id]
  subnets = [
    var.subnet_for_app.id,
    var.subnet_for_app2.id,
  ]
}

resource "aws_alb_target_group" "alb_target_app" {
  name        = "alb-target-for-${var.app_name}"
  port        = var.ecs_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_main.id

  health_check {
    matcher = 200
    port    = var.ecs_container_port
    path    = var.lb_health_check_path
  }
}

resource "aws_alb_listener" "listner_app" {
  load_balancer_arn = aws_alb.app.id
  port              = var.ecs_container_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_app.id
    type             = "forward"
  }
}

resource "aws_security_group" "load_balancers_ecs" {
  name        = "load_balancers_for_app_${var.app_name}"
  description = "Allows all traffic"
  vpc_id      = var.vpc_main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

