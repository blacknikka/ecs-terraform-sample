resource "aws_cloudwatch_log_group" "main" {
  name              = var.cloudwatch_name
  retention_in_days = var.retention_in_days

  tags = {
    Name = var.cloudwatch_name
  }
}
