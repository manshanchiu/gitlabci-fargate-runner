# gitlab-runner on fargate

## References
1. [Autoscale on AWS fargate](https://docs.gitlab.com/runner/configuration/runner_autoscale_aws_fargate/)
2. [AWS fargate custom executor](https://gitlab.com/gitlab-org/ci-cd/custom-executor-drivers/fargate)
3. [Existing fargate sample](https://gitlab.com/aws-fargate-driver-demo)
4. [IAM role on AWS ECS](https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-iam-roles.html)
5. [Kaniko](https://docs.gitlab.com/ee/ci/docker/using_kaniko.html)


## Notes

1. can use private subnets for both manager and runner but need to set EnablePublicIP = false

2. security group must allow both gitlab and manager ssh in.

3. as it is using ssh to run commands so it will lose all env set in the docker image. we need to reset it in gitlab cicd setting
DOCKER_CONFIG = /kaniko/.docker/
DOCKER_CREDENTIAL_GCR_CONFIG = /kaniko/.config/gcloud/docker_credential_gcr_config.json
PATH = /go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin/:/kaniko