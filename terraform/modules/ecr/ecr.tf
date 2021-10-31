resource "aws_ecr_repository" "repo" {
  name                 = "repo_${var.app_name}"
  image_tag_mutability = "MUTABLE"
}
