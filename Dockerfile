FROM ubuntu:latest
RUN apt update && apt install -y bash clang ca-certificates curl wget gnupg lsb-release unzip fuse-overlayfs python3 python3-pip
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl -o awscliv2.zip -L https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && unzip awscliv2.zip && ./aws/install
RUN mkdir -m 0755 -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN adduser runner
RUN groupadd docker||true
RUN usermod -aG docker runner && newgrp docker
USER runner
WORKDIR /home/runner
RUN mkdir actions-runner && cd actions-runner
RUN curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.302.1/actions-runner-linux-x64-2.302.1.tar.gz && tar xzf ./actions-runner.tar.gz
CMD ./config.sh --unattended --replace --url https://github.com/ocr-service --token $TOKEN && ./run.sh
