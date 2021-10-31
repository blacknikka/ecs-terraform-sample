
# Execution role
output "execution_role" {
  value = aws_iam_role.ecs_execution_role
}

# Task role
output "task_role" {
  value = aws_iam_role.ecs_task_role
}
