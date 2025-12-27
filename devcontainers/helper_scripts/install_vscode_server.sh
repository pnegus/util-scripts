#!/bin/sh
set -e

PLATFORM="${1}"
ARCH="${2}"

if [ -z "${PLATFORM}" ]; then
    echo "Error: please enter a platform (e.g., alpine, linux)"
    exit 1
fi

commit_sha=$(curl --silent "https://update.code.visualstudio.com/api/commits/stable/linux-arm64" | sed s'/^\["\([^"]*\).*$/\1/')

if [ -n "${commit_sha}" ]; then
    echo "Downloading VS Code Server version = '${commit_sha}' for ${PLATFORM}"
    if [ "${PLATFORM}" = "alpine" ]; then
        DOWNLOAD_URL="https://update.code.visualstudio.com/commit:${commit_sha}/server-alpine-arm64/stable"
    else
        DOWNLOAD_URL="https://update.code.visualstudio.com/commit:${commit_sha}/server-linux-${ARCH}/stable"
    fi

    archive="vscode-server.tar.gz"
    
    echo "Downloading from: $DOWNLOAD_URL"
    curl -L "$DOWNLOAD_URL" -o "/tmp/${archive}"

    filesize=$(wc -c < "/tmp/${archive}")
    if [ "$filesize" -lt 1000 ]; then
        echo "Error: Downloaded file is too small. URL likely invalid."
        cat "/tmp/${archive}"
        exit 1
    fi

    target_dir="$HOME/.vscode-server/bin/${commit_sha}"
    mkdir -vp "$target_dir"

    tar --no-same-owner -xzv --strip-components=1 -C "$target_dir" -f "/tmp/${archive}"
    
    cd "$HOME/.vscode-server/bin" && ln -sf "${commit_sha}" default_version
    
    echo "VS Code Server pre-installed successfully."
else
    echo "Error: Could not determine latest commit SHA."
    exit 1
fi