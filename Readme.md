### terraform
example of ECS/ECR

### Login ECR
```bash
$ aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 012345678901.dkr.ecr.ap-northeast-1.amazonaws.com/repo_app
```
