output "vpc_main" {
  value = aws_vpc.main
}

output "subnet_for_app" {
  value = aws_subnet.public_a
}

output "subnet_for_app2" {
  value = aws_subnet.public_c
}
