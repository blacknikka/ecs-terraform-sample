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


locals {
  ecs_log_gropu_name = "/ecs/example/${var.base_name}"
}


# Cloudwatch logs
module "ecs_cloudwatch" {
  source = "./modules/cloudwatch-log"

  cloudwatch_name   = local.ecs_log_gropu_name
  retention_in_days = 30
}

# Execution role
module "ecs_execution_role" {
  source = "./modules/ecs-execution-role"

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS cluster
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  base_name = var.base_name
}

# ECS task
data "template_file" "app_task_definition" {
  template = file("${path.module}/app-task.json")

  vars = {
    image_url      = "${module.app_ecr.ecr_repo.repository_url}:1.0"
    name           = "app"
    region         = data.aws_region.current.name
    log_group_name = local.ecs_log_gropu_name
    SOMETHING_ENV1 = "env1"
    SOMETHING_ENV2 = "env2"
  }
}

# ECR
module "app_ecr" {
  source = "./modules/ecr"

  app_name = "app"
}


module "app_ecs" {
  source = "./modules/ecs"

  app_name             = "app"
  base_name            = var.base_name
  vpc_main             = module.network.vpc_main
  subnet_for_app_a     = module.network.subnet_for_app_a
  subnet_for_app_c     = module.network.subnet_for_app_c
  ecs_cluster          = module.ecs_cluster.ecs_cluster
  ecs_task_definition  = data.template_file.app_task_definition.rendered
  ecs_container_name   = "app"
  ecs_container_port   = 8080
  lb_health_check_path = "/"
  ecs_execution_role   = module.ecs_execution_role.execution_role

}
