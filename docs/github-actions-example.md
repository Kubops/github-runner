


```yaml
name: Build

on:
  push:
    branches:
      - '**'

jobs:
  build-branch:
    name: Build
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v2

      - name: Login to DockerHub
        uses: docker/login-action@v1 
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Build image
        uses: docker/build-push-action@v2
        with:
          push: true
          context: .
          file: ./Dockerfile
```