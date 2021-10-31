output "vpc_main" {
  value = aws_vpc.main
}

output "subnet_for_app_a" {
  value = aws_subnet.public_a
}

output "subnet_for_app_c" {
  value = aws_subnet.public_c
}
