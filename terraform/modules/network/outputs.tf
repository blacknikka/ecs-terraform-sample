output "vpc_main" {
  value = aws_vpc.main
}

output "subnet_for_app_a" {
  value = aws_subnet.private_a
}

output "subnet_for_app_c" {
  value = aws_subnet.private_c
}
