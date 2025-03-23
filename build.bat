@echo off
docker buildx create --use --name multiarch
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/mbytesdev/prusaconnectcam:latest . --push
docker buildx rm multiarch
