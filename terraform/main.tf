terraform {
  required_version = ">= 1.0.0"
    backend "s3" {
      region  = "ap-northeast-1"
      encrypt = true

      bucket = "terraform-bucket-for-tfstate"
      key    = "ecs-sample-terraform.tfstate"
    }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "network" {
  source = "./modules/network"

  base_name = var.base_name
}

# ECS cluster
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  base_name = var.base_name
}

# # ECS task
# data "template_file" "app_task_definition" {
#   template = file("${path.module}/ap-task.json")

#   vars = {
#     image_url          = "${module.app_ecr.ecr_repo.repository_url}:latest"
#     name               = "app"
#     region             = data.aws_region.current.name
#     log_group_name     = aws_cloudwatch_log_group.for_ecs.name
#     SOMETHING_ENV1     = "env1"
#     SOMETHING_ENV2     = "env2"
#   }
# }

# # ECR
# module "app_ecr" {
#   source = "./modules/ecr"

#   app_name = "app"
# }


# module "app" {
#   source = "./modules/ecs"

#   app_name             = "app"
#   base_name            = var.base_name
#   vpc_main             = module.network.vpc_main
#   subnet_for_app       = module.network.subnet_for_app
#   subnet_for_app2      = module.network.subnet_for_app2
#   ecs_cluster          = module.ecs_cluster.main
#   ecs_task_definition  = data.template_file.app_task_definition.rendered
#   ecs_container_name   = "app"
#   ecs_container_port   = 8080
#   lb_health_check_path = "/"
#   ecs_execution_role   = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

# }
