# docker commands

## local

```shell
docker build --build-arg SERVICE_ENV=dev -t learn-nextjs:dev .
docker run -d --name learn-nextjs -p 3000:3000 learn-nextjs:dev
```

## prod 배포

### ECR 업로드

```shell
AWS_REGION="ap-northeast-2"
AWS_ACCOUNT_ID="558826674374"
SERVICE_NAME="learn-nextjs"
SERVICE_ENV="dev"
JENKINS_BUILD_ID=${BUILD_ID}

# ECR 로그인
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# 이미지 빌드 및 태깅
docker build --build-arg SERVICE_ENV=${SERVICE_ENV}  -t $SERVICE_NAME .
docker tag $SERVICE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVICE_NAME:${JENKINS_BUILD_ID}

# 이미지 푸시
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$SERVICE_NAME:${JENKINS_BUILD_ID}
```
