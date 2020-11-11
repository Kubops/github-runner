FROM ubuntu:20.04

ENV GITHUB_PAT ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_LABELS ""
ENV RUNNER_WORKDIR "workspace"

# Update and download dependencies
RUN apt-get update \
    && apt-get install -y libssl-dev sudo git curl iputils-ping jq wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m runner \
    && usermod -aG sudo runner \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Download Docker for container builds on Kubernetes
ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 19.03.13
RUN wget -O docker.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" \
    && tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ \
    && rm docker.tgz

# Directory for runner to operate in
USER runner
WORKDIR /home/runner

# Download Docker Buildx
ENV BUILDX_VERSION v0.4.2
RUN wget -O docker-buildx "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" \
    && chmod a+x docker-buildx \
    && mkdir -p ~/.docker/cli-plugins \
    && mv docker-buildx ~/.docker/cli-plugins/docker-buildx

# Download Actions runner
RUN GITHUB_RUNNER_VERSION=$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | jq -r '.tag_name[1:]') \
    && curl -Ls https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz \
    && sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && sudo ./bin/installdependencies.sh

COPY --chown=runner:runner entrypoint.sh ./entrypoint.sh
RUN sudo chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/runner/entrypoint.sh"]