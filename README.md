# GitHub Actions Self Hosted Runners on Kubernetes #

This repository includes all the content needed to deploy a GitHub Actions Self-Hosted Runners into your Kubernetes cluster.

## Features ## 

- Only a Github Personal Access Token (PAT) is needed.
- Docker Buildx plugins included.
- Based on Ubuntu 20.04.
- Docker in Docker (DnD) sidecar.

## Getting Started ##

### Prerequisites ###

You'll need to create a Github Personal Access Token (PAT) following [these instructions](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token). Github self-hosted runners can either be connected to a single repository or to a GitHub organization, so for a single repository the PAT should have **repo** scope. If the self-hosted runner should be added to an organization, the PAT should have **admin:org** scope.

You'll have to create a secret resource with the Github Personal Access Token (PAT) and the GitHub organization name:

```bash
kubectl create secret generic -n default github-runner --from-literal=GITHUB_OWNER="username-or-organization" --from-literal=GITHUB_PAT="github-personal-access-token"
```

### Installation ###

After you create the secret resource called `github-runner`,  you'll be able to apply the manifest file from the repository to your Kubernetes:

```bash
kubectl apply -f https://raw.githubusercontent.com/Kubops/github-runner/v1.0.1/manifests/deployment.yaml
```

## Resources ##

Guides and reference documents are available at [`docs`](docs/).

## Based on ##

This work is a simple alternative based on:

- https://github.com/SanderKnape/github-runner
- https://github.com/summerwind/actions-runner-controller
- https://github.com/lazybit-ch/actions-runner
- https://github.com/evryfs/github-actions-runner-operator/

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for details.

## License ##

It is distributed under the MIT license. See [`LICENSE.md`](LICENSE.md) for more information.
