
# ELB DNS name
output "lb_dns_name" {
  value = aws_alb.app.dns_name
}

# security group
output "security_group" {
  value = aws_security_group.load_balancers_ecs
}
