# gitlab-runner on fargate



## Notes

1. can use private subnets for both manager and runner but need to set EnablePublicIP = false

2. security group must allow both gitlab and manager ssh in.

3. as it is using ssh to run commands so it will lose all env set in the docker image. we need to reset it in gitlab cicd setting
DOCKER_CONFIG = /kaniko/.docker/
DOCKER_CREDENTIAL_GCR_CONFIG = /kaniko/.config/gcloud/docker_credential_gcr_config.json
PATH = /go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin/:/kaniko