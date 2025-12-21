FROM golang:alpine

RUN apk add --no-cache \
    git \
    make \
    gcc \
    curl \
    dig

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /workspace

ENV SHELL=/bin/bash

CMD ["sleep", "infinity"]