#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
    echo "Error, script accepts only one arg."
    echo "Usage: ./build_and_deploy_devcontainer.sh <dockerfile_dir>"
    exit 1
fi

DEVCONTAINER_LANGUAGE="$1"

case "$DEVCONTAINER_LANGUAGE" in
    golang|python)
        ;;
    *)
        echo "Error: Invalid argument '$DEVCONTAINER_LANGUAGE'."
        echo "Allowed arguments: golang, python"
        exit 1
        ;;
esac

PLATFORM="linux/arm64"
CONTAINER_DIR="${DEVCONTAINER_LANGUAGE}_devcontainer"
DOCKERFILE_PATH="${CONTAINER_DIR}/Dockerfile"
IMAGE_NAME="${CONTAINER_DIR}"
CONTAINER_NAME="${CONTAINER_DIR}"

if [ ! -d "$CONTAINER_DIR" ]; then
    echo "Error: Directory '$CONTAINER_DIR' not found."
    exit 1
fi

if [ ! -f "$DOCKERFILE_PATH" ]; then
    echo "Error: Dockerfile not found at '$DOCKERFILE_PATH'."
    exit 1
fi

echo "building image '${IMAGE_NAME}:latest' for platform ${PLATFORM}..."
docker build \
    --platform "$PLATFORM" \
    -t "${IMAGE_NAME}:latest" \
    -f "$DOCKERFILE_PATH" \
    "$CONTAINER_DIR"

echo "checking for old containers..."

if [ "$(docker ps -aq -f name="^${CONTAINER_NAME}$")" ]; then
    echo "found old containers, removing..."
    docker rm -f "$CONTAINER_NAME"
else
    echo "no old containers found."
fi

echo "deploying new devcontainer '$CONTAINER_NAME'..."

docker run -dt \
    --cap-add=SYS_PTRACE \
    --security-opt=no-new-privileges \
    --name "$CONTAINER_NAME" \
    --platform linux/arm64 \
    "${IMAGE_NAME}:latest"

docker ps -f name="^${CONTAINER_NAME}$"