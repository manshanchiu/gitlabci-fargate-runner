setup-credential:
	aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin ${ECR_URI}
deploy-manager: setup-credential
	cd manager && docker build -t gitlab-runner-manager .
	docker tag gitlab-runner-manager:latest ${ECR_URI}/${ECR_REPO}:manager
	docker push ${ECR_URI}/${ECR_REPO}:manager
deploy-runner: setup-credential
	cd runner && docker build -t gitlab-runner .
	docker tag gitlab-runner:latest ${ECR_URI}/${ECR_REPO}:runner
	docker push ${ECR_URI}/${ECR_REPO}:runner