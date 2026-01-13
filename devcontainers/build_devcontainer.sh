#!/bin/bash

set -e

if [ "$#" -ne 2 ]; then
    echo "Error, script accepts 2 arguments."
    echo "Usage: ./build_and_deploy_devcontainer.sh <language> <local | remote>"
    exit 1
fi

DEVCONTAINER_LANGUAGE="$1"

case "$1" in
    "golang")
        CACHE_DIR="/go/pkg/mod"
        ;;
    "python")
        CACHE_DIR="/home/devuser/.cache/uv"
        ;;
    "debian_generic")
        CACHE_DIR="/home/devuser/misc_cache"
        ;;
    *)
        echo "Invalid option: $1"
        echo "Usage: script.sh [golang|python|debian_generic]"
        exit 1
        ;;
esac


case "$2" in
    "local")
        WRAPPER_COMMAND=""
        ;;
    *)
        WRAPPER_COMAND="wrapper"
        ;;
esac

PLATFORM="linux/arm64"
CONTAINER_DIR="${DEVCONTAINER_LANGUAGE}_devcontainer"
DOCKERFILE_PATH="${CONTAINER_DIR}/Dockerfile"
IMAGE_NAME="${CONTAINER_DIR}"
CONTAINER_NAME="${CONTAINER_DIR}"
SHARED_FOLDER="$HOME/git"

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
    --no-cache \
    --build-context helper_scripts=helper_scripts \
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

REGION="us-east-1"

mkdir -p "$HOME/devcontainer_cache/${CONTAINER_NAME}_cache"

SSM_PATHS=()

# Define specific SSM parameter paths for each devcontainer type
case "$DEVCONTAINER_LANGUAGE" in
    "golang")
        SSM_PATHS=(
            "/apikeys//aws"
            "/apikeys//cloudflare"
        )
        ;;
    "python")
        SSM_PATHS=(
            "/apikeys/APCA_SECRET"
            "/apikeys/APCA_API_BASE_URL"
            "/apikeys/APCA_KEY"
            "/apikeys/GEMINI_API_KEY"
        )
        ;;
    "debian_generic")
        ;;
esac

echo "deploying new devcontainer '$CONTAINER_NAME'..."

docker run -dt \
    --env-file <( \
        $WRAPPER_COMMAND aws ssm get-parameters \
        --region "$REGION" \
        --names ${SSM_PATHS[@]} \
        --with-decryption \
        --output json \
        | jq -r '.Parameters[] | "\(.Name | split("/") | last)=\(.Value)"' \
    ) \
    -v "$SHARED_FOLDER:/workspace" \
    -v "$HOME/devcontainer_cache/${CONTAINER_NAME}_cache:$CACHE_DIR" \
    --security-opt=no-new-privileges \
    --name "$CONTAINER_NAME" \
    --platform "$PLATFORM" \
    "${IMAGE_NAME}:latest"

docker ps -f name="^${CONTAINER_NAME}$"