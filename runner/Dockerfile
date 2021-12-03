FROM gcr.io/kaniko-project/executor AS kaniko

FROM golang:1.16.10
RUN apt-get update \
    && apt-get install -y python3 python3-pip zip jq 

# ----------------------------------------
# Install aws command
# ----------------------------------------
RUN pip3 install --upgrade pip && pip3 install --no-cache-dir awscli

#RUN apt-get install zip -y
#RUN apt-get install -qq -y jq

# ---------------------------------------------------------------------
# Install https://github.com/krallin/tini - a very small 'init' process
# that helps processing signalls sent to the container properly.
# ---------------------------------------------------------------------
#ARG TINI_VERSION=v0.19.0

#RUN curl -Lo /usr/local/bin/tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 \
#    && chmod +x /usr/local/bin/tini
RUN apt-get install tini
# --------------------------------------------------------------------------
# Install and configure sshd.
# https://docs.docker.com/engine/examples/running_ssh_service for reference.
# --------------------------------------------------------------------------
RUN apt-get install -y openssh-server \
    && mkdir -p /var/run/sshd

EXPOSE 22

# ----------------------------------------
# Install GitLab CI required dependencies.
# ----------------------------------------
ARG GITLAB_RUNNER_VERSION=v12.9.0

RUN curl -Lo /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/${GITLAB_RUNNER_VERSION}/binaries/gitlab-runner-linux-amd64 \
    && chmod +x /usr/local/bin/gitlab-runner

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash 
RUN apt-get install git-lfs 
RUN git lfs install --skip-repo
ENV PATH="${PATH}:/usr/local/go/bin/"

# ----------------------------------------
# Install Terraform command
# ----------------------------------------
RUN wget https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip
RUN unzip terraform*.zip
RUN mv terraform /usr/local/bin

# ----------------------------------------------------------------
# Copy the kaniko executable and cloud container registry helpers.
# Then, set up the tool.
# ----------------------------------------------------------------
COPY --from=kaniko /kaniko/executor /kaniko/
COPY --from=kaniko /kaniko/docker-credential-gcr /kaniko/
COPY --from=kaniko /kaniko/docker-credential-gcr /usr/local/bin
COPY --from=kaniko /kaniko/docker-credential-ecr-login /kaniko/
COPY --from=kaniko /kaniko/docker-credential-ecr-login /usr/local/bin
COPY --from=kaniko /kaniko/docker-credential-acr /kaniko/
COPY --from=kaniko /kaniko/docker-credential-acr /usr/local/bin

ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json
ENV PATH ${PATH}:/kaniko

RUN mkdir -p /kaniko/.docker \
    && mkdir -p /kaniko/ssl \
    && docker-credential-gcr config --token-source=env \
    && echo '{"credsStore":"ecr-login"}' > /kaniko/.docker/config.json


# ----------------------------------------
# Install nodejs
# ----------------------------------------
RUN apt-get install -y nodejs npm

# ----------------------------------------
# Install serverless
# ----------------------------------------
RUN npm install serverless -g




# -------------------------------------------------------------------------------------
# Execute a startup script.
# https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data
# for reference.
# -------------------------------------------------------------------------------------
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["tini", "--", "sh","/usr/local/bin/docker-entrypoint.sh"]