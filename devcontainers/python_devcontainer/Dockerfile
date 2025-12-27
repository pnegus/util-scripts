FROM python:slim-bookworm

RUN apt update && apt install -y \
    curl \
    vim \
    unar 

COPY --from=helper_scripts install_vscode_server.sh /install_vscode_server.sh
COPY requirements.txt /requirements.txt
RUN chmod +x /install_vscode_server.sh

RUN groupadd --system devgroup && useradd --create-home --system --gid devgroup devuser
RUN chown -R devuser:devgroup /usr/local
USER devuser

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
RUN uv pip install -r /requirements.txt --system

RUN /install_vscode_server.sh debian arm64