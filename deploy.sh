if [ $# -eq 0  ] || [ -z "$1" ] || { [ $1 != "manager" ] && [ $1 != "runner" ]; } then
    echo "==> invalid command line argument. supported values are manger and runner"
    exit 1
fi

export ECR_URI=635353606081.dkr.ecr.ap-southeast-1.amazonaws.com
export ECR_REPO=gitlab-runner

if [ "$1" = "manager" ]; then 
    make deploy-manager
else
    make deploy-runner
fi;
