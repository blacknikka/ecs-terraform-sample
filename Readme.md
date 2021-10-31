### terraform
example of ECS/ECR

### Login ECR
```bash
$ aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 012345678901.dkr.ecr.ap-northeast-1.amazonaws.com/repo_app
```

### ECS Exec
- In order to use ECS Exec, `enableExecuteCommand` should be `true`.
  - It is able to confirm with below command whether `enableExecuteCommand` status is true or nor.

```bash
$ aws ecs describe-services \
    --cluster ecs-sample \
    --services ecs_app

$ aws ecs describe-tasks \
    --cluster ecs-sample \
    --tasks XXXXXXXXXXXXXXXXX
```

- It is able to access ECS instance without SSH

```bash
$ aws ecs execute-command \
    --cluster ecs-sample \
    --task XXXXXXXXXXXXXXXXX \
    --container app \
    --interactive \
    --command "sh"
```
