FROM python:slim-bookworm

ENV UV_LINK_MODE=copy

RUN apt update && apt install -y \
    curl \
    vim 

COPY --from=helper_scripts install_vscode_server.sh /install_vscode_server.sh
RUN chmod +x /install_vscode_server.sh

RUN groupadd --system devgroup && useradd --create-home --system --gid devgroup devuser
RUN usermod -s /bin/bash devuser
RUN chown -R devuser:devgroup /usr/local
USER devuser

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

RUN /install_vscode_server.sh debian arm64