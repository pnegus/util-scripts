FROM golang:alpine

RUN apk add --no-cache \
    vim \
    git \
    make \
    gcc \
    musl-dev \
    curl \
    gcompat \
    libstdc++ 

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

RUN addgroup -S devgroup && adduser -S -s /bin/sh devuser -G devgroup

COPY --from=helper_scripts install_vscode_server.sh /install_vscode_server.sh
RUN chmod +x /install_vscode_server.sh

USER devuser

RUN /install_vscode_server.sh alpine arm64

