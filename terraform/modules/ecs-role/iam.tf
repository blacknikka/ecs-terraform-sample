# ----------------
# execution role (ecs)
# ----------------
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role_${var.base_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = var.policy_arn
}

# ----------------
# task role (ecs)
# ----------------
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role_${var.base_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "enable_ssm" {
  name   = "enable_ssm_${var.base_name}"
  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*"
    }
  ]
}
EOT
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.enable_ssm.arn
}

