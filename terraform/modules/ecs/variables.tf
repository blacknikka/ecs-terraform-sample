# base name
variable "base_name" {}

# application name
variable "app_name" {}

# ecs cluster
variable "ecs_cluster" {}

# template json file
variable "ecs_task_definition" {}

# container name
variable "ecs_container_name" {}

# container port
variable "ecs_container_port" {}

# health check path for LB
variable "lb_health_check_path" {}

# execution role
variable "ecs_execution_role" {}

# vpc to exec the container
variable "vpc_main" {}

# subnet 1 to exec the container
variable "subnet_for_app" {}

# subnet 2 to exec the container
variable "subnet_for_app2" {}
