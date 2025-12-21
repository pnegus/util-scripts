FROM golang:alpine

RUN apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    curl 

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /workspace