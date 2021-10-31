# application task definition
resource "aws_ecs_task_definition" "app_task" {
  family                = "app_task_${var.app_name}"
  network_mode          = "awsvpc"
  cpu                   = 256
  memory                = 512
  container_definitions = var.ecs_task_definition
  execution_role_arn    = var.ecs_execution_role.arn

  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "app" {
  name            = "ecs_${var.app_name}"
  cluster         = var.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on = [
    var.ecs_execution_role,
    aws_alb_listener.listner_app,
  ]

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_app.id
    container_name   = var.ecs_container_name
    container_port   = var.ecs_container_port
  }

  network_configuration {
    subnets = [
      var.subnet_for_app.id,
      var.subnet_for_app2.id,
    ]

    security_groups = [
      aws_security_group.load_balancers_ecs.id,
    ]

    assign_public_ip = true
  }
}
